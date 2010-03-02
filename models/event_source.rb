require 'dm-core'
require 'rss'
require 'memcache'

class EventSource
  include DataMapper::Resource

  property :id, Serial
  property :feed_url, String

  def events
    cache = MemCache.new(ENV['MEMCACHE_SERVERS'].split(','),
                         ENV['MEMCACHE_NAMESPACE'])
    events = cache.get("event_source_#{@id}")

    if events
      events
    else
      events = RSS::Parser.parse(@feed_url, false).items
      cache.set("event_source_#{@id}", events, 86400)
      events
    end
  end
end
