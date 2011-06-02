require 'rubygems'
require "bundler"
Bundler.require(:default)

require 'sintara'

set :public, File.dirname(__FILE__) + '/public'

get "/" do
  redirect '/index.html'
end