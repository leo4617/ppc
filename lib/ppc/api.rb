require 'ppc/api/baidu'
require 'ppc/api/sogou'
module PPC
  module API
    attr_reader :header,:body,:rquota,:quota,:status,:desc,:oprs,:oprtime,:code,:message
    attr_accessor :username,:password,:token,:debug
  end
end
