require 'bundler'
Bundler.setup

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 
require 'juno-report'
require 'rspec/autorun'

RSpec.configure do |config|
	config.color_enabled = true
	config.formatter     = 'documentation'
end