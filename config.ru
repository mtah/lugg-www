require 'appengine-rack'
require 'main'

AppEngine::Rack.configure_app(
  :application => 'lugg-www',
  :version => 5)

#configure :development do
#  class Sinatra::Reloader < ::Rack::Reloader
#    def safe_load(file, mtime, stderr)
#      ::Sinatra::Application.reset!
#      super
#    end
#  end
#  use Sinatra::Reloader
#  use Sinatra::ShowExceptions
#end

run Sinatra::Application