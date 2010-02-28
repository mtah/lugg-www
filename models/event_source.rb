require 'dm-core'
require 'appengine-apis/memcache'
require 'appengine-apis/urlfetch'
require 'rss'

class EventSource
  include DataMapper::Resource

  property :id, Serial
  property :feed_url, String

  def events
    cache = AppEngine::Memcache.new(:namespace => "events")
    events = cache.get(@id)

    if events
      events
    else
      rawfeed = AppEngine::URLFetch.fetch(@feed_url)
      events = RSS::Parser.parse(rawfeed.body, false).items
      cache.set(@id, events, 86400)
      events
    end
  end
end
