# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'markup_matcher/version'

Gem::Specification.new do |spec|
  spec.name        = 'markup_matcher'
  spec.version     = MarkupMatcher::VERSION
  spec.author      = 'Isaac Dudek'
  spec.email       = 'isaac@isaacdudek.com'
  spec.summary     = ''
  spec.description = ''
  spec.homepage    = 'https://github.com/isaacdudek/markup_matcher'
  spec.license     = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) {|file| File.basename file}
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
