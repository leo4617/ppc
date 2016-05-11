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
        # special case solution
        # 只有account getInfo 的key 为 '',因为其特殊逻辑,单独处理
        result = { }
        if response == []
          result[:succ] = true
          result[:failure] = nil
          result[:result] = nil
          result[:no_quota] = false
          return result
        end
        if key == ''
          if !response['failures'].nil?
            result[:succ] = false
            result[:result] = nil
            result[:failure] = response['failures']
            result[:no_quota] = is_no_quota(response['failures'], '90401')
            return result
          end
          result[:succ] = true
          result[:failure] = nil
          result[:no_quota] = false
          result[:result] = func[response]
          return result
        end
        result[:result] = func[response[key]]
        result[:failure] = response['failures']
        result[:no_quota] = is_no_quota(response['failures'], '90401')
        result[:succ] = response['failures'].nil? || response['failures'].size.zero?
        #if response['failures'] != nil
        #  result[:succ] = false
        #  result[:failure] = response['failures']['item']
        #  result[:result] = nil
        #else
        #  result[:succ] = true
        #  result[:result] = func[ key==''? response : response[ key ] ]
        #  result[:failure] = failure_key == ''? nil : response[ failure_key ]
        #end
        return result
      end

      def self.to_json_string( items )
        '''
        convert list of string/int to list of json string
        '''
        return '' if items == nil
        items = [items] unless items.is_a? Array
        items_str = []
        items.each{ |x| items_str << x.to_s }
        items_str.to_json
      end

      def self.to_id_list( ids_str )
        return [] if ids_str == nil
        ids_str = [ids_str] unless ids_str.is_a? Array
        ids_i = []
        ids_str.each{ |id| ids_i<<id.to_i }
        ids_i
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

    end
  end
end
