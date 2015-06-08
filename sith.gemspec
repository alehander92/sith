# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'sith'
  s.version     = '0.1.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alexander Ivanov"]
  s.email       = ["alehander42@gmail.com"]
  s.homepage = 'https://github.com/alehander42/sith'
  s.summary     = %q{A macro preprocessor for Ruby}
  s.description = %q{A macro preprocessor for Ruby with ruby-like template notation}

  s.add_development_dependency 'rspec', '~> 0'
  s.add_runtime_dependency('parser', '~> 2.2')
  s.add_runtime_dependency('unparser', '~> 0.2')

  s.license       = 'MIT'
  s.executables   = ["sith"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
