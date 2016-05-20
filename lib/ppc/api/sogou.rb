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
        result[:succ]   = response[:header][:desc] == 'success'
        result[:failure] = response[:header][:failures]
        result[:no_quota] = (response[:header][:failures][:code] == '18') rescue false
        result[:result] = func[ response[:body][ key.snake_case.to_sym ] ] rescue nil
        result[:rquota] = response[:header][:rquota] if response[:header][:rquota]
        result
      end

    end
  end
end

