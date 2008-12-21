require 'digest/md5'

module ActiveRecord
  
  class Base

    # table_names is a special attribute that contains a regular expression with all the tables of the application
    # Its main purpose  is to detect all the tables that a query affects.
    # It is build in a special way:
    #   - first we get all the tables
    #   - then we sort them from major to minor lenght, in order to detect tables which name is a composition of two
    #     names, i.e, posts, comments and comments_posts. It is for make easier the regular expression
    #   - and finally, the regular expression is built
    cattr_accessor :table_names, :enableMemcacheQueryForModels
    
    self.table_names = /#{connection.tables.sort_by { |c| c.length }.join('|')}/i
    self.enableMemcacheQueryForModels ||= {}

    class << self
            
      # put this class method at the top of your AR model to enable memcache for the queryCache, 
      # otherwise it will use standard query cache
      def enable_memcache_querycache(options = {})
        if ActionController::Base.perform_caching && defined?(::Rails.cache) && ::Rails.cache.is_a?(ActiveSupport::Cache::MemCacheStore)
          options[:expires_in] ||= 90.minutes
          self.enableMemcacheQueryForModels[ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s] = options
        else
          warning = "[Query memcached WARNING] Disabled for #{ActiveRecord::Base.send(:class_name_of_active_record_descendant, self)} -- Memcache for QueryCache is not enabled for this model because caching is not turned on, Rails.cache is not defined, or cache engine is not mem_cache_store"
          ActiveRecord::Base.logger.error warning
        end
      end
      
      def connection_with_memcache_query_cache
        conn = connection_without_memcache_query_cache
        conn.memcache_query_cache_options = self.enableMemcacheQueryForModels[self.to_s]
        conn
      end
      
      alias_method_chain :connection, :memcache_query_cache
      
      def cache_version_key(table_name = nil)
        "#{global_cache_version_key}/#{table_name || self.table_name}"
      end

      def global_cache_version_key; 'version' end

      # Increment the class version key number
      def increase_version!(table_name = nil)
        key = cache_version_key(table_name)
        if r = ::Rails.cache.read(key)
          ::Rails.cache.write(key, r.to_i + 1)
        else
          ::Rails.cache.write(key, 1)
        end
      end
      
      # Given a sql query this method extract all the table names of the database affected by the query
      # thanks to the regular expression we have generated on the load of the plugin
      def extract_table_names(sql)
        sql.gsub(/`/,'').scan(self.table_names).map {|t| t.strip}.uniq
      end

    end

  end

  module ConnectionAdapters # :nodoc:
    
    class AbstractAdapter
      attr_accessor :memcache_query_cache_options
    end

    class MysqlAdapter < AbstractAdapter
      
      # alias_method_chain for expiring cache if necessary
      def execute_with_clean_query_cache(*args)
        return execute_without_clean_query_cache(*args) unless self.memcache_query_cache_options && query_cache_enabled
        sql = args[0].strip
        if sql =~ /^(INSERT|UPDATE|ALTER|DROP|DELETE)/i
          # can only modify one table at a time...so stop after matching the first table name
          table_name = ActiveRecord::Base.extract_table_names(sql).first
          ActiveRecord::Base.increase_version!(table_name)
        end
        execute_without_clean_query_cache(*args)
      end

      alias_method_chain :execute, :clean_query_cache
      
    end
    
    class PostgreSQLAdapter < AbstractAdapter

      def execute_with_clean_query_cache(*args)
        return execute_without_clean_query_cache(*args) unless self.memcache_query_cache_options && query_cache_enabled
        sql = args[0].strip
        if sql =~ /^(INSERT|UPDATE|ALTER|DROP|DELETE)/i
          table_name = ActiveRecord::Base.extract_table_names(sql).first
          ActiveRecord::Base.increase_version!(table_name)
        end
        execute_without_clean_query_cache(*args)
      end
      
      alias_method_chain :execute, :clean_query_cache
      
    end
    
    module QueryCache
    
      # Enable the query cache within the block
      def cache
        old, @query_cache_enabled = @query_cache_enabled, true
        @query_cache ||= {}
        @cache_version ||= {}
        yield
      ensure
        @query_cache_enabled = old
        clear_query_cache
      end
    
      # Clears the query cache.
      #
      # One reason you may wish to call this method explicitly is between queries
      # that ask the database to randomize results. Otherwise the cache would see
      # the same SQL query and repeatedly return the same result each time, silently
      # undermining the randomness you were expecting.
      def clear_query_cache
        @query_cache.clear if @query_cache
        @cache_version.clear if @cache_version
      end
    
      private
    
      def cache_sql(sql)
        # priority order:
        #  - if in @query_cache (memory of local app server) we prefer this
        #  - else if exists in Memcached we prefer that
        #  - else perform query in database and save memory caches
        result =
          if (query_cache_enabled || self.memcache_query_cache_options) && @query_cache.has_key?(sql)
            log_info(sql, "CACHE", 0.0)
            @query_cache[sql]
          elsif self.memcache_query_cache_options && cached_result = ::Rails.cache.read(query_key(sql), self.memcache_query_cache_options)
            log_info(sql, "MEMCACHE", 0.0)
            @query_cache[sql] = cached_result
          else
            query_result = yield
            @query_cache[sql] = query_result if query_cache_enabled || self.memcache_query_cache_options            
            ::Rails.cache.write(query_key(sql), query_result, self.memcache_query_cache_options) if self.memcache_query_cache_options
            query_result
          end
    
        if Array === result
          result.collect { |row| row.dup }
        else
          result.duplicable? ? result.dup : result
        end
      rescue TypeError
        result
      end
    
      # Transforms a sql query into a valid key for Memcache
      def query_key(sql)
        table_names = ActiveRecord::Base.extract_table_names(sql)
        # version_number is the sum of the global version number and all 
        # the version numbers of each table
        version_number = get_cache_version # global version 
        table_names.each { |table_name| version_number += get_cache_version(table_name) }
        "#{version_number}_#{Digest::MD5.hexdigest(sql)}"
      end
    
      # Returns the cache version of a table_name. If table_name is empty its the global version
      #
      # We prefer to search for this key first in memory and then in Memcache
      def get_cache_version(table_name = nil)
        key_class_version = table_name ? ActiveRecord::Base.cache_version_key(table_name) : ActiveRecord::Base.global_cache_version_key
        if @cache_version && @cache_version[key_class_version]
          @cache_version[key_class_version]
        elsif version = ::Rails.cache.read(key_class_version)
          @cache_version[key_class_version] = version if @cache_version
          version
        else
          @cache_version[key_class_version] = 0 if @cache_version
          ::Rails.cache.write(key_class_version, 0)
          0
        end
      end
    
    end
    
  end
end