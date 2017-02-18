# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "danmaq"
  spec.version       = "0.1.0"
  spec.authors       = ["Shuhei Nomura"]
  spec.email         = ["info@danmaq.com"]

  spec.summary       = "Hello, world"
  spec.homepage      = "https://github.com/danmaq/danmaq.jekyll"
  spec.license       = "MIT"

  spec.files         = %w[LICENSE README]
  spec.files        += Dir.glob("assets/**/*")
  spec.files        += Dir.glob("_layouts/**/*")
  spec.files        += Dir.glob("_includes/**/*")
  spec.files        += Dir.glob("_sass/**/*")

  spec.add_runtime_dependency "jekyll", "~> 3.4"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.8"
  spec.add_runtime_dependency "redcarpet", "~> 3.4"

  #spec.add_development_dependency "bundler", "~> 1.12"
  #spec.add_development_dependency "rake", "~> 10.0"
end
