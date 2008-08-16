if Object.const_defined?( 'ActionController' )
  require 'query_memcached' if ActionController::Base.perform_caching
end