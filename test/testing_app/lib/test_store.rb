module ActiveSupport
  module Cache
    class TestStore < Store

      attr_reader :written, :deleted, :deleted_matchers

      def initialize
        @data = {}
        @written = []
        @deleted = []
        @deleted_matchers = []
      end
      
      def exist?(name,options = nil)
        super
        @data.has_key?(name)
      end

      def clear
        @data.clear
        @written.clear
        @deleted.clear
        @deleted_matchers.clear
      end

      def read(name, options = nil)
        super
        @data[name]
      end

      def write(name, value, options = nil)
        super
        @written.push(name)
        @data[name] = value
      end

      def delete(name, options = nil)
        @deleted.push(name)
        super
        @data.delete(name)
      end

      def delete_matched(matcher, options = nil)
        @deleted_matchers.push(matcher)
        @data.delete_if { |k,v| k =~ matcher }
      end

      def written?(name)
        @written.include?(name)
      end

      def deleted?(name)
        @deleted.include?(name) || @deleted_matchers.detect { |matcher| name =~ matcher }
      end

    end
  end
end
