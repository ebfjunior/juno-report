# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'juno-report/version'

Gem::Specification.new do |gem|
    gem.name = "juno-report"
    gem.version = JunoReport::VERSION
    gem.platform    = Gem::Platform::RUBY
    gem.authors = ["Edson Júnior"]
    gem.email = ["ejunior.batista@gmail.com"]
    gem.description = "A simple, but efficient, report genarator yaml based"
    gem.summary = "Juno Reports generates reports with the minimum configuration and effort"
    gem.homepage = "http://github.com/ebfjunior/juno-report"

    gem.files = `git ls-files`.split("\n")
    gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
    gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
    gem.require_paths = ["lib"]

    gem.add_dependency "prawml"

    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'rspec'
end
