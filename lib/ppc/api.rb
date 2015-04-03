require 'awesome_print'
require 'net/http'
require 'net/https'
require 'httparty'
require 'json'
require 'ppc/api/baidu'
require 'ppc/api/sogou'
require 'ppc/api/qihu'
require 'ppc/api/sm'

module PPC
  module API
    attr_reader :header,:body,:rquota,:quota,:status,:desc,:oprs,:oprtime,:code,:message
    attr_accessor :username,:password,:token,:debug
  end
end
