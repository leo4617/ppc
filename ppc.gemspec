# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# require ppc for version
require 'ppc'

puts """################ WARNING #################
#  Savon 3.0 is not avaliable on gem source.
#  Please download it from github, 
#  checkout savon3 branch and install manually.
##########################################""" 

Gem::Specification.new do |spec|
  spec.name          = "ppc"
  spec.version       = PPC::VERSION
  spec.authors       = ["Chienli Ma", "刘梦晨", "刘明", "范捷琦"]
  spec.email         = ["maqianlie@gmail.com", "liuyu_tc@163.com", "seoaqua@qq.com", "fjqqiqi@163.com"]
  spec.summary       = %q{ppc api for  baidu qihu sogou}
  spec.description   = %q{ppc api for  baidu qihu sogou}
  spec.homepage      = "https://github.com/warriors-of-the-night/ppc"
  spec.license       = "GNU"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', '~> 0.13', '>= 0.13.0'
  spec.add_dependency 'savon',  '~> 3.0', '>= 3.0.0'
  spec.add_dependency 'awesome_print'
end
