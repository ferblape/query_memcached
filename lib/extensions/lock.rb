# Experimental LOCK support ported form http://github.com/fauna/interlock/tree/master/lib/interlock/lock.rb
module ActiveSupport
  module Cache
    class MemCacheStore < Store

      def lock(key, lock_expiry = 30, retries = 5)
        retries.times do |count|

          begin
            response = @data.add("lock:#{key}", "Locked by #{Process.pid}", lock_expiry)
            response ||= Response::STORED
          rescue Object => e
          end

          if response == Response::STORED
            begin
              value = yield( @data.get(key) )
              @data.set(key, value)
              return value
            ensure
              @data.delete("lock:#{key}")
            end
          else
            sleep((2**count) / 2.0)
          end
        end
      end

    end
  end
end