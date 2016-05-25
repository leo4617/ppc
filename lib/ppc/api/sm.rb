# -*- coding:utf-8 -*-
require 'ppc/api/sm/account'
require 'ppc/api/sm/plan'
require 'ppc/api/sm/bulk'
require 'ppc/api/sm/group'
require 'ppc/api/sm/keyword'
require 'ppc/api/sm/report'
require 'ppc/api/sm/creative'
module PPC
  module API
    class Sm

      extend ::PPC::API

      def self.request_uri(param = {})
        URI("https://e.sm.cn/api/#{param[:service]}/#{param[:method]}")
      end

      def self.process( response, key, &func)
        '''
        Process Http response. If operation successes, return value of given keys.
        You can process the result using function &func, or do nothing by passing 
        block {|x|x}
        =========================== 
        @Output: resultType{ desc: boolean, failure: Array,  result: Array }

        failure is the failures part of response\'s header
        result is the processed response body.
        '''
        result = {}
        result[:succ] = response['header']['desc'] =='success'
        result[:failure] = response['header']['failures']
        result[:result] = func[ response['body'][key] ] rescue nil
        result[:no_quota] = (response['header']['failures']['code'] == '8501') rescue true
        result[:rquota] = response["header"]["leftQuota"] rescue 0
        result
      end # process

    end # Sm
  end # API
end # PPC
