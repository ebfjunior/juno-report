require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper")

describe "Generating a report" do
	it "YAML file should exist" do
		data = require 'data/data1.rb'
		lambda {JunoReport::generate data, report: File.expand_path('spec/data/rule1')}.should_not raise_error Errno::ENOENT
	end

	it "Invalid YAML file should crash" do
		data = require 'data/data1.rb'
		lambda {JunoReport::generate data, report: 'fake-rule'}.should raise_error Errno::ENOENT
	end
end