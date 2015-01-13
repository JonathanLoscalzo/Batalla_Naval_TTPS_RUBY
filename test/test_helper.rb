ENV['RACK_ENV'] = 'test'

require 'minitest/spec'
require 'minitest/autorun'
require File.expand_path '../../app', __FILE__ # => File.expand_path '../Gemfile', File.dirname(__FILE__)

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Application # => acà va el nombre de la aplicacion Modular Sinatra
  end
end
