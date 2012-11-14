# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'juno-report/version'

Gem::Specification.new do |gem|
    gem.name = "juno-report"
    gem.version = Juno::Report::VERSION
    gem.authors = ["Edson Júnior"]
    gem.email = ["ejunior.batista@gmail.com"]
    gem.description = "A Complete Report Generator"
    gem.summary = ""
    gem.homepage = ""

    gem.files = `git ls-files`.split($/)
    gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
    gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
    gem.require_paths = ["lib"]

    gem.add_dependency "prawml"
end
