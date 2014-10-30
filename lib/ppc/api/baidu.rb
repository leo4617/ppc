# -*- coding:utf-8 -*-
require 'ppc/api/baidu/account'
require 'ppc/api/baidu/plan'
require 'ppc/api/baidu/bulk'
require 'ppc/api/baidu/group'
require 'ppc/api/baidu/keyword'
require 'ppc/api/baidu/report'
require 'ppc/api/baidu/creative'
require 'awesome_print'
require 'net/http'
require 'net/https'
require 'json'
module PPC
  module API
    class Baidu

      @map = nil
<<<<<<< HEAD
      @@debug = false

      def self.debug_on
        @@debug = true
      end

      def self.debug_off
        @@debug = false
=======
      @debug = false

      def debug_on
        @debug = true
      end

      def debug_off
        @debug = false
>>>>>>> 4a00421517647bde99febdbd50bac7af3f068520
      end

      def self.request( auth, service, method, params = {} )
        '''
        request should return whole http response including header
        '''
        uri = URI("https://api.baidu.com/json/sms/v3/#{service}Service/#{method}")
        http_body = {
          header: {
            username:   auth[:username],
            password:   auth[:password],
            token:      auth[:token]
          },
          body: params
        }.to_json

        http_header = {
          'Content-Type' => 'application/json; charset=UTF-8'
        }

        http = Net::HTTP.new(uri.host, 443)
        # 是否显示http通信输出
<<<<<<< HEAD
        http.set_debug_output( $stdout ) if @@debug
=======
        http.set_debug_output( $stdout ) if @debug
>>>>>>> 4a00421517647bde99febdbd50bac7af3f068520
        http.use_ssl = true

        response = http.post(uri.path, http_body, http_header)
        response = JSON.parse response.body

        # return response if with_header else response['body']
      end

      def self.process( response, key,  debug = false , &func)
        '''
        Process Http response. If operation successes, return value of given keys.
        You can process the result using function &func, or do nothing by passing 
        block {|x|x}
        =========================== 
        @Output: resultType{ desc: boolean, failure: Array,  result: Array }
        failure is the failures part of response\'s header
        result is the processed response body.
        '''
        # debug当初为调试所用，现在失效
        # 相关代码暂时保留， 未来将会移除
        # return response if debug

        result = {}
        result[:succ] = response['header']['desc']=='success'? true : false
        result[:failure] = response['header']['failures']
        result[:result] = func[ response['body'][key] ]
        return result
      end # process

      def self.make_type( params, map = @map)
        '''
        tranfesr ppc api to search engine api
        @ input
          params : list of hash complying with PPC gem api  
          map : list of pairs(lists) of symbol complying with following api
          map = [ 
                        [ ppc_key, api_key ],
                        [ ppc_key, api_key ],
                        [ ppc_key, api_key ],
                                        ...
                        ]
          Ex: 
          baidu_group_map = [ [ :id, :adgroupId],
                                                  [ :price, :maxPrice],
                                                          ...                 ]
        ===================
        @ output:
        : types : list of hash that complying with search engine api
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
        transfer search engine api to ppc api
        @ input
          types : list of hash that complying with search engine api
          map : list of pairs(lists) of symbol, for more details please 
                      read docs of make_type()
        ===================
        @ output:
          params : list of hash complying with PPC gem api  
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

      end # Baidu
  end # API
end # PPC
