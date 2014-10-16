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
        http.set_debug_output $stderr
        http.use_ssl = true

        response = http.post(uri.path, http_body, http_header)
        response = JSON.parse response.body

        # return response if with_header else response['body']
      end

      def self.process( response, key , test = false ,  &func)
        '''
        Process Http response. If operation successes, return value of given keys.
        You can process the result using function &func, or do nothing by passing 
        block {|x|x}
        
        If operation fails, return \'failures\' and response body if there is some messages
        '''
        if test 
          return response 
        elsif response['header']['desc'] == 'success'
          return func[ response['body'][ key ] ]
        else
          result = {}
          result[:desc] = response['header']['desc']
          result[:faliure] = response['header']['failures']
          result[:info] = func[ response['body'][ key ] ]
          return result
        end
      end # process

      end # Baidu
  end # API
end # PPC
