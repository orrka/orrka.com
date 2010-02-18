
require 'toto'
require 'haml'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

# Set up Compass/Sass
require 'sass/plugin/rack'
require 'compass'
use Sass::Plugin::Rack
Compass.configuration do |config|
  config.project_path = File.dirname(__FILE__)
  config.sass_dir = "sass"
  config.css_dir = "public/css"
  config.output_style = :compact
end
Compass.configure_sass_plugin!

# syntax highlighting
gem 'coderay'       # get one of supported highlighters 
require 'coderay'   

gem 'hyperbolist-rack-codehighlighter'
require 'rack/codehighlighter'

use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/
use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false


if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  # 
  # set :author,    ENV['USER']                               # blog author
  # set :title,     Dir.pwd.split('/').last                   # site title
  # set :root,      "index"                                   # page to load on /
  # set :date,      lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
  set :markdown,  :smart                                    # use markdown + smart-mode
  # set :disqus,    false                                     # disqus id, or false
  # set :summary,   :max => 150, :delim => /~/                # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds
  set :to_html, lambda {|path, page, binding| Haml::Engine.new(File.read("#{path}/#{page}.haml")).render(binding) }
  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }

  
end

run toto


