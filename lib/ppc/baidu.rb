require 'ppc/baidu/account'
require 'ppc/baidu/plan'
require 'ppc/baidu/bulk'
require 'ppc/baidu/group'
require 'ppc/baidu/key'
require 'ppc/baidu/report'
require 'awesome_print'
require 'net/http'
require 'net/https'
require 'json'
# require 'savon'
module PPC
  class Baidu
    include ::PPC



    def request(method,params = {}, with_header = false)
      uri = URI("https://api.baidu.com/json/sms/v3/#{@service}/#{method}")
      http_body = {
        header: request_header,
        body: params
      }.to_json

      http_header = {
        'Content-Type' => 'application/json; charset=UTF-8'
      }

      http = Net::HTTP.new(uri.host, 443)
      http.set_debug_output $stderr
      http.use_ssl = true

      response = http.post(uri.path, http_body, http_header)
      response =  (JSON.parse response.body)
      # if not needed, only return body
      return response['body'] unless with_header else response
    end

    def operations
    end

    protected
    def download(params = {})
      bulk = ::PPC::Baidu::Bulk.new({
                                      username: @username,
                                      password: @password,
                                      token:    @token,
                                      debug:    @debug
      })

      params[:extended] = params[:extended] || 2

      begin
        file_id = bulk.file_id_of_all(params)
        puts "file_id: #{file_id}" if @debug

        loop do
          state = bulk.state(file_id)
          raise "invalid file state: #{state}" unless %w(1 2 3 null).include? state
          break if state == '3'
          puts "waiting for #{file_id} to be ready. current state:#{state}" if @debug
          sleep 3
        end
        puts "#{file_id} is ready" if @debug
        return bulk.path(file_id)
      rescue
        # @header   = bulk.header
        # @oprs     = bulk.oprs
        # @oprtime  = bulk.oprtime
        # @quota    = bulk.quota
        # @rquota   = bulk.rquota
        # @status   = bulk.status

        # @desc     = bulk.desc

        # case @desc
        # when 'success'
        # when 'failure'
        #   @code     = bulk.code
        #   @message  = bulk.message
        # when 'system failure'
        #   @code     = bulk.code
        #   @message  = bulk.message
        # else
        #   raise "unknown desc from baidu: #{@desc}"
        # end
        raise BulkException.new(file_id,bulk)
      end

      return false
    end

    private


    def request_header
      {
        username:   @username,
        password:   @password,
        token:      @token
      }
    end

    def example(operation,with_header=false)
      operation = make_operation(operation)
      if with_header
        {
          example_header: operation.example_header,
          example_body:   operation.example_body
        }
      else
        operation.example_body
      end
    end

    def process_response(response)
      body = response[:envelope]
      print_debug(body,'response.envelope') if @debug
      @header = body[:header]
      res_header = header[:res_header]

      @oprs     = res_header[:oprs]
      @oprtime  = res_header[:oprtime]
      @quota    = res_header[:quota]
      @rquota   = res_header[:rquota]
      @status   = res_header[:status]

      @desc     = res_header[:desc]
      case @desc
      when 'success'
      when 'failure'
        failures  = res_header[:failures]
        @code     = failures[:code]
        @message  = failures[:message]
      when 'system failure'
        failures  = res_header[:failures]
        @code     = failures[:code]
        @message  = failures[:message]
      else
        raise "unknown desc from baidu: #{@desc}"
      end
    end

  end
end
