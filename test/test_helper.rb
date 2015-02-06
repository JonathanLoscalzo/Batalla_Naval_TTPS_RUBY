ENV['RACK_ENV'] = 'test'
# para correr test bundle exec rake db:migrate RACK_ENV=test

require 'simplecov'

SimpleCov.start

require 'minitest/autorun'
require 'rack/test'
require File.expand_path '../../app', __FILE__ # => File.expand_path '../Gemfile', File.dirname(__FILE__)
include Rack::Test::Methods


def app
  Application
end