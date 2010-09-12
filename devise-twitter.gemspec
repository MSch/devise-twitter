# -*- encoding: utf-8 -*-
require File.expand_path("../lib/devise/twitter/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "devise-twitter"
  s.version     = Devise::Twitter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Martin Schuerrer']
  s.email       = ['martin@schuerrer.org']
  s.homepage    = "http://rubygems.org/gems/devise-twitter"
  s.summary     = "Out of the box support for signing in via Twitter  and connecting an existing account to Twitter"
  s.description = ""

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "devise-twitter"

  # FIXME: Seems like bundler can't handle [">= 1.1.0", "< 1.3.0"]
  s.add_dependency "devise", ">= 1.1.0"
  s.add_dependency "warden_oauth", "~> 0.1.1"
  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
