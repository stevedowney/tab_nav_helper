require 'rubygems'
require 'spec'
require 'action_view'

Dir[File.dirname(__FILE__) + '/../lib/**/*.rb'].each do |file|
  require file
end
