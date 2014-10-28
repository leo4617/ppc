require 'savon'



module PPC
  module API
    class Sogou
    
      def self.request( auth, service = @service, method, params )
        '''
        ps. in savon3, .to_hash method will turn CamelXML to snake hash
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

        result = operation.call.to_hash[:envelop]

        #extract header and body
        response = { }
        response[:header] = result[:header][:res_header]
        response[:body] = result[:body][ (method + "Response").snake_case.to_sym ]
        return response
      end

      def process( response, key, debug = false, &func )
        '''
        @input
        : type key : string
        : param key : type name, we will transfer camel string 
                               into snake_case symbol inside the method
        '''
        return response if debug

        result = {}
        result[:succ] = response[:header][desc]=='success'? true : false
        result[:failure] = response[:header][:failures]
        result[:result] = func[ response[:body][ key.snake_case.to_sym ] ]
        return result
      end

     def self.make_type( params, map = @map)
        '''
        For more info visit ::PPC::API::Baidu:make_type
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
        For more info visit ::PPC::API::Baidu:reverse_type
        '''
        types = [ types ] unless types.is_a? Array

        params = []
        types.each do |type|
          param = {}
          
            map.each do |key|
                # do not to transfer to string
                value = type[ key[1] ]
                param[ key[0] ] = value if value != nil
            end

          params << param
        end
        return params
      end



    end
  end
end

