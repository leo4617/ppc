require 'ppc/operation/account'
require 'ppc/operation/group'
require 'ppc/operation/plan'
require 'ppc/operation/key'



module PPC
  module Operation
    def initialize(params)
      @id   = params[:id]
      @se   = params[:se]
      @auth = {
        username: params[:username],
        password: params[:password],
        token:    params[:token]
      }
    end

    def call(service)
      Object.const_get "::PPC::API::#{@se.capitalize}::#{service.capitalize}"
    end

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
  end
end
