require 'dm-core'
require 'rss'
require 'memcache'

class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :feed_url, String

  def has_feed?
    not self.feed_url.nil?
  end

  def newest_feed_item
    cache = MemCache.new(ENV['MEMCACHE_SERVERS'].split(','),
                         ENV['MEMCACHE_NAMESPACE'])
    feed_item = cache.get("user_#{@id}")

    if feed_item
      feed_item
    else
      feed_item = RSS::Parser.parse(@feed_url, false).items.first
      cache.set("user_#{@id}", feed_item, 3600)
      feed_item
    end
  end
end

