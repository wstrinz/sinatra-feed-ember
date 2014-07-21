Encoding.default_internal = Encoding.default_external = 'UTF-8'

def path_to(dir)
  File.join(File.dirname(__FILE__), dir)
end

require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'

require 'erb'
require 'haml'
require 'sass/plugin/rack'

require 'feedjira'

# Require classes needed for project
require path_to('lib/foo')
require path_to('lib/models/feed.rb')

use Sass::Plugin::Rack

configure do
  set :views, File.expand_path(path_to 'views')
  set :public_folder, File.expand_path(path_to 'public')
  set :haml, { :attr_wrapper => '"', :format => :html5 }
  set :database, { adapter: "sqlite3", database: "feed-ember.sqlite3" }
end

configure :development do
  require 'sinatra/reloader'
  Sinatra::Application.also_reload "lib/**/*.rb"
end

helpers do
  def em(text)
    "<em>#{text}</em>"
  end
end

not_found do
  haml :not_found
end

error do
  haml :error
end

get '/' do
  @foo ||= Foo.new
  erb :index
end

get '/feeds' do
  @foo = Feed.all.count
  erb :index
end

get '/greetings/:name' do
  haml :greetings
end
