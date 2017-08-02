# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pf/version"

Gem::Specification.new do |spec|
  spec.name          = "pf"
  spec.version       = PF::VERSION
  spec.authors       = ["Zhu Ran"]
  spec.email         = ["zhuran94@163.com"]

  spec.summary       = %q{a cloud storage tool }
  spec.description   = %q{You can view, download or upload files via your public cloud storage service accounts}
  spec.homepage      = "https://rubygems.org/gems/pf"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["pf"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "qiniu", ">= 6.8.1"
  spec.add_development_dependency "thor", ">= 0.19.4"
end
