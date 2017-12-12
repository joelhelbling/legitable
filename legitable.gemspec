
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "legitable/version"

Gem::Specification.new do |spec|
  spec.name          = "legitable"
  spec.version       = Legitable::VERSION
  spec.authors       = ["Joel Helbling"]
  spec.email         = ["joel@joelhelbling.com"]

  spec.summary       = %q{Plain text tables}
  spec.description   = %q{Tables are easier to read.  Legitable makes it easy to display plain text output in tabular form.}
  spec.homepage      = "https://github.com/joelhelbling/legitable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16.a"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "rspec-given", "~> 3.8"
  spec.add_development_dependency "pry", "~> 0.11"
end
