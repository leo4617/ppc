require 'ppc/api/sogou/account'
require 'ppc/api/sogou/plan'
require 'ppc/api/sogou/group'
require 'ppc/api/sogou/keyword'
require 'ppc/api/sogou/report'
require 'ppc/api/sogou/creative'
require 'ppc/api/sogou/bulk'

module PPC
  module API
    class Sogou

      extend ::PPC::API

      def self.request( auth, service, method, params = {})
        '''
        ps. in savon3, .hash method will turn CamelXML to snake hash
        preprocess response, extract 
        '''

        service = service + "Service"
        client = Savon.new( "http://api.agent.sogou.com:8080/sem/sms/v1/#{service}?wsdl" )
        operation = client.operation( service, service, method )

        operation.header = { 
          AuthHeader:{
          username:   auth[:username],
          password:   auth[:password],
          token:      auth[:token]
        }
        }
        operation.body = {  (method+'Request').to_sym => params }
        # debug print
        debug_print( operation ) if @debug
        result = operation.call.hash[:envelope]
        #extract header and body
        response = { }
        response[:header] = result[:header][:res_header]
        response[:body] = result[:body][ (method + "Response").snake_case.to_sym ]
        # debug print
        puts response if @debug
        return response
      end

      def self.debug_print( operation )
        puts '{:header=>' + operation.header.to_s + ',  :body=>' + operation.body.to_s + '}'
      end

      def self.process( response, key, &func )
        '''
        @input
        : type key : string
        : param key : type name, we will transfer camel string 
                               into snake_case symbol inside the method
        '''
        result = {}
        result[:succ] = response[:header][:desc]=='success'? true : false
        result[:failure] = response[:header][:failures]
        result[:no_quota] = is_no_quota(response[:header][:failures], '18')
        unless response[:body].nil? or response[:body][key.snake_case.to_sym].nil?
          result[:result] = func[ response[:body][ key.snake_case.to_sym ] ]
        end
        return result
      end

      #      def self.make_type( params, map = @map)
      #        '''
      #        For more info visit ::PPC::API::sogou:make_type
      #        '''
      #        params = [ params ] unless params.is_a? Array
      #
      #        types = []
      #        params.each do |param|
      #          type = {}
      #
      #          map.each do |key|
      #            value = param[ key[0] ]
      #            type[ key[1] ] = value if value != nil
      #          end
      #
      #          types << type
      #        end
      #        return types
      #      end
      def self.reverse_type( types, maps = @map )
        types = [ types ] unless types.is_a? Array
        types.map do |item| 
          maps.each{|m| item.filter_and_replace_key(m[0],m[1].to_s.snake_case.to_sym)}
          item
        end
      end

      #      def self.reverse_type( types, map = @map )
      #        '''
      #        For more info visit ::PPC::API::sogou:reverse_type
      #        Here, the camel key will be turn into snake key
      #        '''
      #        types = [ types ] unless types.is_a? Array
      #
      #        params = []
      #        types.each do |type|
      #          param = {}
      #
      #          map.each do |key|
      #            # 这里做两次转换并不是十分高效的方法，考虑maintain两张map
      #            value = type[ key[1].to_s.snake_case.to_sym ]
      #            param[ key[0] ] = value if value != nil
      #          end

      #          params << param
      #        end
      #        return params
      #      end

    end
  end
end

