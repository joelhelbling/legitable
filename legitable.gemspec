lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "legitable/version"

Gem::Specification.new do |spec|
  spec.name = "legitable"
  spec.version = Legitable::VERSION
  spec.authors = ["Joel Helbling"]
  spec.email = ["joel@joelhelbling.com"]

  spec.summary = "Easy plain text tables"
  spec.description = "Tables are easier to read.  Legitable makes it easy to display plain text output in tabular form."
  spec.homepage = "https://github.com/joelhelbling/legitable"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|\.vim.*|\.rspec.*)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.rc"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "rspec-given", "~> 3.8"
  spec.add_development_dependency "pry", "~> 0.11"
end
