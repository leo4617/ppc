require 'ppc/api/baidu/account'
require 'ppc/api/baidu/plan'
require 'ppc/api/baidu/bulk'
require 'ppc/api/baidu/group'
require 'ppc/api/baidu/key'
require 'ppc/api/baidu/report'
require 'awesome_print'
require 'net/http'
require 'net/https'
require 'json'
# require 'savon'
module PPC
  module API
    module Baidu

      def request( auth, service, method, params = {}, with_header = false)
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

        return response if with_header else response['body']
      end

      # private
      # def process_response(response)
      #   body = response[:envelope]
      #   print_debug(body,'response.envelope') if @debug
      #   @header = body[:header]
      #   res_header = header[:res_header]

      #   @oprs     = res_header[:oprs]
      #   @oprtime  = res_header[:oprtime]
      #   @quota    = res_header[:quota]
      #   @rquota   = res_header[:rquota]
      #   @status   = res_header[:status]

      #   @desc     = res_header[:desc]
      #   case @desc
      #   when 'success'
      #   when 'failure'
      #     failures  = res_header[:failures]
      #     @code     = failures[:code]
      #     @message  = failures[:message]
      #   when 'system failure'
      #     failures  = res_header[:failures]
      #     @code     = failures[:code]
      #     @message  = failures[:message]
      #   else
      #     raise "unknown desc from baidu: #{@desc}"
      #   end
      # end 
    end
  end
end
