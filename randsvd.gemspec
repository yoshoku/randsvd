# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'randsvd/version'

Gem::Specification.new do |spec|
  spec.name          = 'randsvd'
  spec.version       = RandSVD::VERSION
  spec.authors       = ['yoshoku']
  spec.email         = ['yoshoku@outlook.com']

  spec.summary       = %q{RandSVD is a class that performs truncated singular
                          value decomposition using a randomized algorithm.}
  spec.homepage      = 'https://github.com/yoshoku/randsvd'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nmatrix', '~> 0.2.3'
  spec.add_runtime_dependency 'nmatrix-lapacke', '~> 0.2.3'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
