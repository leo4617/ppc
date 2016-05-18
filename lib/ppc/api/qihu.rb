# -*- coding:utf-8 -*-
require 'ppc/api/qihu/account'
require 'ppc/api/qihu/plan'
require 'ppc/api/qihu/group'
require 'ppc/api/qihu/keyword'
require 'ppc/api/qihu/creative'
require 'ppc/api/qihu/report'
require 'ppc/api/qihu/sublink'
require 'ppc/api/qihu/bulk'
require 'ppc/api/qihu/rank'

module PPC
  module API
    class Qihu

      extend ::PPC::API

      def self.request_uri(param = {})
        URI("https://api.e.360.cn/2.0/#{param[:service]}/#{param[:method]}")
      end

      def self.request_http_header(auth)
        {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'apiKey' => auth[:api_key],
          'accessToken' => auth[:token],
          'serveToken' => Time.now.to_i.to_s
        }
      end

      def self.request_http_body(auth, params = {})
        params["format"] = 'json'
        params.map{|k,v| "#{k.to_s}=#{v.to_s}"}.join('&')
      end

#      def self.request( auth, service, method, params = {} )
#        p 123
#        url = "https://api.e.360.cn/2.0/#{service}/#{method}"
#        # 日后考虑将httpparty用Net/http代替
#        response = HTTParty.post(url, 
#                body: params,
#                headers: {'apiKey' => auth[:api_key], 
#                                'accessToken' => auth[:token], 
#                                'serveToken' => Time.now.to_i.to_s  }
#              )
#        p response 
#        response.parsed_response
#      end

      def self.process( response, key, failure_key = '', &func )
        result = {}
        result[:succ]     = response['failures'].nil? || response['failures'].size.zero?
        result[:failure]  = response['failures']
        result[:result]   = func[response[key]] rescue nil
        result[:result] ||= func[response]
        result[:no_quota] = is_no_quota(response['failures'], '90401') rescue false
        result
      end

    end
  end
end
