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

      def process( response, key, debug = false, &func )
        content = response[ key ]
        result = { }
        if content.keys.include? 'failures'
          result[:succ] = false
          result[:failure] = content['failures']['item']
          result[:result] = nil
        else
          result[:result] = func[ content ]
          result[:succ] = true
          result[:failure] = nil
        end
        return result
      end

    end
  end
end