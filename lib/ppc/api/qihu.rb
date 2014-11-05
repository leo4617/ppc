# -*- coding:utf-8 -*-
require 'ppc/api/qihu/account'
require 'httparty'

module PPC
  module API
    class Qihu

      def self.request( auth, service, method, params = {} )
        url = "https://api.e.360.cn/2.0/#{service}/#{method}"
        # 日后考虑将httpparty用Net/http代替
        response = HTTParty.post(url, 
                body: params,
                headers: {'apiKey' => auth[:token], 
                                'accessToken' => auth[:accessToken], 
                                'serveToken' => Time.now.to_i.to_s  }
              )

        response.parsed_response
      end

      def self.process( response, key, failure_key = '', &func )
        p response
        response_key = response.keys[0]
        content = response[ response_key ]
        # special case solution
        if content == nil
          return{ succ:true, failure:nil, result:nil }
        end

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

      def self.make_type( params, map = @map)
        '''
        '''
        params = [ params ] unless params.is_a? Array

        types = []
        params.each do |param|
          type = {}

            map.each do |key|
              value = param[ key[0] ]
              type[ key[1] ] = value if value != nil
            end

          types << type
        end
        return types
      end

      def self.reverse_type( types, map = @map )
        '''
        '''
        types = [ types ] unless types.is_a? Array

        params = []
        types.each do |type|
          param = {}
          
            map.each do |key|
                value = type[ key[1].to_s ]
                param[ key[0] ] = value if value != nil
            end

          params << param
        end
        return params
      end


    end
  end
end