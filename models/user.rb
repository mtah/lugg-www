require 'dm-core'
require 'appengine-apis/memcache'
require 'appengine-apis/urlfetch'
require 'rss'

class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :feed_url, String

  def has_feed?
    not self.feed_url.nil?
  end

  def newest_feed_item
    cache = AppEngine::Memcache.new(:namespace => "feed_items")
    feed_item = cache.get(@id)

    if feed_item
      feed_item
    else
      rawfeed = AppEngine::URLFetch.fetch(@feed_url)
      feed_item = RSS::Parser.parse(rawfeed.body, false).items.first
      cache.set(@id, feed_item, 3600)
      feed_item
    end
  end
end

