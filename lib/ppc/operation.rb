module PPC
  module Operation

    attr_accessor :id
    
    def initialize( params )
      raise 'please specific a search engine'                     if params[:se].nil?

      @se = params[:se]
      @id = params[:id]
      @auth = {
        username: params[:username],
        password: params[:password],
        # 在qihu360的api中，apikey就是auth[:token]
        token:    params[:token],
        target:   params[:target]
      }
      # add support for qihu360
      if @se == 'qihu'
        raise "you are using qihu service, please enter api_key"    if params[:api_key].nil?
        raise "you are using qihu service, please enter api_secret" if params[:api_secret].nil?
        @auth[:api_key]     = params[:api_key]
        @auth[:api_secret]  = params[:api_secret]
        @auth[:token]       = qihu_refresh_token if params[:token].nil? 
      end
    end

    def qihu_refresh_token
        cipher_aes = OpenSSL::Cipher::AES.new(128, :CBC)
        cipher_aes.encrypt
        cipher_aes.key = @auth[:api_secret][0,16]
        cipher_aes.iv = @auth[:api_secret][16,16]
        encrypted = (cipher_aes.update(Digest::MD5.hexdigest( @auth[:password])) + cipher_aes.final).unpack('H*').join
        url = "https://api.e.360.cn/account/clientLogin"
        response = HTTParty.post(url,
          :body => {
          :username => @auth[:username],
          :passwd => encrypted[0,64]
          },
          :headers => {'apiKey' => @auth[:api_key] }
        )
        data = response.parsed_response
        data["account_clientLogin_response"]["accessToken"]
    end

    def download( param = nil )
        """
        download all objs of an account
        """
        eval("::PPC::API::#{@se.capitalize}::Bulk").download( @auth, param )
    end

    def call(service)
      eval "::PPC::API::#{@se.capitalize}::#{service.capitalize}"
    end

    # +++++ Plan opeartion funcitons +++++ #
    module Plan_operation

      def method_missing(method_name, *args, &block)
        if method_name.to_s[/_plan$/]
          call( "plan" ).send(method_name.to_s[/^(get|add|update|delete|enable|pause)/], @auth, [args].flatten )
        else
          super
        end
      end

    end

    # +++++ Group opeartion funcitons +++++ #
    module Group_operation

      def method_missing(method_name, *args, &block)
        if method_name.to_s[/_group$/]
          call( "group" ).send(method_name.to_s[/^(get|add|update|delete|enable|pause)/], @auth, [args].flatten )
        else
          super
        end
      end

    end

    # +++++ Keyword opeartion funcitons +++++ #
    module Keyword_operation

      def method_missing(method_name, *args, &block)
        if method_name.to_s[/_keyword$/]
          call( "keyword" ).send(method_name.to_s[/^(get|add|update|delete|enable|pause)/], @auth, [args].flatten )
        else
          super
        end
      end

    end

    # +++++ Creative opeartion funcitons +++++ #
    module Creative_operation

      def method_missing(method_name, *args, &block)
        if method_name.to_s[/_creative$/]
          call( "creative" ).send(method_name.to_s[/^(get|add|update|delete|enable|pause)/], @auth, [args].flatten )
        else
          super
        end
      end

    end

  end # Opeartion
end # PPC

# requires are moved to the end of the file
# because if we load files before defining the 
# module ::PPC::Operation. Errors of 'uninitialized constance'
# will occur
require 'ppc/operation/report'
require 'ppc/operation/account'
require 'ppc/operation/group'
require 'ppc/operation/plan'
require 'ppc/operation/keyword'
require 'ppc/operation/creative'

