# -*- coding:utf-8 -*-
require 'ppc/api/qihu/account'
require 'httpparty'

module PPC
  module API
    class Qihu
      def request( auth, service, method, params = {} )
        url = "https://api.e.360.cn/#{service}/#{method}"
        # 日后考虑将httpparty用Net/http代替
        response = HTTParty.post(url, 
                body: params,
                headers: {'apiKey' => auth[:token], 
                                'accessToken' => auth[:accesstoken], 
                                'serveToken' => Time.now.to_i.to_s  }
              )
        response.parsed_response
      end

      def process( response, key, failure_key = '', &func )
        response_key = response.keys[0]
        content = response[ response_key ]
        result = { }
        if content.keys.include? 'failures'
          result[:succ] = false
          result[:failure] = content['failures']['item']
          result[:result] = nil
        else
          result[:succ] = true
          result[:result] = func[ key==''? content : content[ key ] ]
          result[:failure] = failure_key == ''? nil : content[ failure_key ]
        end
        return result
      end

      def ids_to_string( ids )
        ids = ids unless ids.is_a? Array
        ids_str = []
        ids.each{ |x| ids_str << x.to_s }
        ids_str
      end

    end
  end
end