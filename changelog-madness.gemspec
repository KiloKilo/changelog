
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "changelog/version"

Gem::Specification.new do |spec|
  spec.name          = "changelog-madness"
  spec.version       = Changelog::VERSION
  spec.authors       = ["Alexandre Joly"]
  spec.email         = ["alexandre.joly@kilokilo.ch"]

  spec.summary       = %q{Stop the changelog merge conflict madness}
  spec.description   = %q{A tool to create changelog entries and bind them together}
  spec.homepage      = "https://github.com/KiloKilo/changelog"
  spec.license       = "MIT"

  
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  # add dependencies
  spec.add_dependency 'thor', '~> 0'
  spec.add_dependency 'colorize', '~> 0.8'
  spec.add_dependency 'activesupport', '~> 4.2'

  # add dependencies specially for development needs
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "irb", "~> 1.0.0"

end
