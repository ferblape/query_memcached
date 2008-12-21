class Computer < ActiveRecord::Base
  enable_memcache_querycache
  belongs_to :developer, :foreign_key => 'developer'
end
