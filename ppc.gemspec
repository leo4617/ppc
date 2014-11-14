# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ppc'
Gem::Specification.new do |spec|
  spec.name          = "ppc"
  spec.version       = PPC::VERSION
  spec.authors       = ["Chienli Ma, 刘梦晨， 刘明"]
  spec.email         = ["maqianlie@gmail.com, liuyu_tc@163.com, seoaqua@qq.com"]
  spec.summary       = %q{ppc api for  baidu qihu sogou}
  spec.description   = %q{ppc api for  baidu qihu sogou}
  spec.homepage      = "http://github.com/elong/ppc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
