# -*- encoding: utf-8 -*-
require File.expand_path("../lib/couponing/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "couponing"
  s.version     = Couponing::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/couponing"
  s.summary     = "coupon gem"
  s.description = "a coupon gem"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "couponing"
  
  
  s.add_runtime_dependency 'fastercsv'
  s.add_runtime_dependency 'money'
  s.add_runtime_dependency 'simple_form'
  

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = Dir['app/**/*', 'config/routes.rb', 'lib/**/*']
  # s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
