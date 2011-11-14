# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rmarket/version"

Gem::Specification.new do |s|
  s.name        = "rmarket"
  s.version     = RMarket::VERSION
  s.authors     = ["Ben-Alexander Cassell"]
  s.email       = ["bcassell@umich.edu"]
  s.homepage    = "http://www.github.com/egtaonline/rmarket"
  s.summary     = %q{Classes for modeling market interactions in ruby}
  s.description = %q{rmarket provides classes for modeling market interactions in ruby, such as an order book that operates as a CDA.}

  s.rubyforge_project = "rmarket"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "growl"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "ruby-gsl-ng"
end
