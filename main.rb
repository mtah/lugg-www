require 'sinatra'
require 'dm-core'
require 'haml'
require 'sass'
require 'will_paginate'
require 'will_paginate/collection'

# Configure DataMapper to use the App Engine datastore 
DataMapper.setup(:default, "appengine://auto")

# Load all models
Dir["models/*.rb"].each { |file| require file }

# Load all helpers
require 'helpers.rb'

# Set options
set :sass, {:style => :compressed}

# process stylesheets with Sass
get "/css/:stylesheet.css" do
  content_type "text/css", :charset => "utf-8"
  sass params[:stylesheet].to_sym
end

# index route
get "/" do
  page = request.params["page"].to_i
  page = 1 if page <= 0
  
  per_page = 5
  
  @feed_items = WillPaginate::Collection.create(page, per_page) do |pager|
    items =
      User.all(:feed_url.not => nil).
      map do |u|
        i = u.newest_feed_item
        {  
          :user_name => u.name,
          :title => i.title,
          #:date => time_to_local(i.date),
          :date => i.date,
          :description => i.description,
          :link => i.link
        }
      end.
      sort { |a,b| b[:date] <=> a[:date] }

    start = (page-1)*per_page
    pager.replace(items[start, per_page])
    pager.total_entries = items.size
  end

  haml :index
end

get "/events/?" do
  @events = EventSource.all().
    map { |es| es.events }.
    flatten.
      sort { |a,b| b.published.content <=> a.published.content }
    
  haml :events
end

get "/about/?" do
  haml :about
end

# Load all routes
Dir["routes/*.rb"].each { |file| require file }
