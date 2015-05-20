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

      def self.request_uri(service:, method:)
        URI("https://e.sm.cn/api/#{service}/#{method}")
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
        if !response['body'].nil? && response['body'][key]
          result[:result] = func[ response['body'][key] ]
        end
        result[:no_quota] = is_no_quota(response['header']['failures'], '8501')
        result
      end # process

      def self.reverse_type( types, maps = @map )
        types = [ types ] unless types.is_a? Array
        types.map do |item| 
          maps.each{|m| item.filter_and_replace_key(m[0],m[1].to_s)}
          item
        end
      end

    end # Sm
  end # API
end # PPC
