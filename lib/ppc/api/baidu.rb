# -*- coding:utf-8 -*-
require 'ppc/api/baidu/account'
require 'ppc/api/baidu/plan'
require 'ppc/api/baidu/bulk'
require 'ppc/api/baidu/group'
require 'ppc/api/baidu/keyword'
require 'ppc/api/baidu/report'
require 'ppc/api/baidu/creative'
require 'ppc/api/baidu/phone_new_creative'
require 'ppc/api/baidu/rank'

module PPC
  module API
    class Baidu 

      extend ::PPC::API
      
      def self.request_uri(param)
        URI("https://api.baidu.com/json/sms/v3/#{param[:service]}Service/#{param[:method]}")
      end

      def self.process(response, key, &func)
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
        if !response['body'].nil? && response['body'][key]
          result[:result] = func[ response['body'][key] ]
        end
        result[:no_quota] = is_no_quota(response['header']['failures'], '8501')
        return result
      end

      def self.reverse_type( types, maps = @map )
        types = [ types ] unless types.is_a? Array
        types.map do |item| 
          maps.each{|m| item.filter_and_replace_key(m[0],m[1].to_s)}
          item
        end
      end

    end # Baidu
  end # API
end # PPC
