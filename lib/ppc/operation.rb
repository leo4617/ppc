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
        encrypted = (cipher_aes.update(Digest::MD5.hexdigest(@auth[:password])) + cipher_aes.final).unpack('H*').join
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
      def get_plan( ids )
        call("plan").get(@auth,ids)
      end

      def add_plan( plans )
        call('plan').add(@auth,plans)
      end

      def update_plan( plans )
        call('plan').update(@auth,plans)
      end

      def delete_plan( ids )
        call('plan').delete(@auth,ids)
      end

      def enable_plan( ids )
        call('plan').enable(@auth,ids)
      end

      def pause_plan( ids )
        call('plan').pause(@auth,ids)
      end

    end

    # +++++ Group opeartion funcitons +++++ #
    module Group_operation
      def get_group( ids )
        call("group").get(@auth,ids)
      end

      def add_group( groups )
        call('group').add(@auth,groups )
      end

      def update_group( groups )
        call('group').update( @auth, groups )
      end

      def delete_group( ids )
        call('group').delete( @auth, ids )
      end

      def enable_group( ids )
        call('group').enable(@auth,ids)
      end

      def pause_group( ids )
        call('group').pause(@auth,ids)
      end

    end

    # +++++ Keyword opeartion funcitons +++++ #
    module Keyword_operation
      def get_keyword( ids )
        call("keyword").get(@auth,ids)
      end
      
      def add_keyword( keywords )
        call('keyword').add( @auth, keywords )
      end

      def update_keyword( keywords)
        call('keyword').update( @auth, keywords )
      end

      def delete_keyword( ids )
         call('keyword').delete( @auth, ids )
      end

      def enable_keyword( ids )
        call('keyword').enable(@auth,ids)
      end

      def pause_keyword( ids )
        call('keyword').pause(@auth,ids)
      end

    end

    # +++++ Creative opeartion funcitons +++++ #
    module Creative_operation
      def get_creative( ids )
        call("creative").get(@auth,ids)
      end
      
      def add_creative( creatives )
        call('creative').add( @auth, creatives )
      end

      def update_creative( creatives )
        call('creative').update( @auth, creatives )
      end

      def delete_creative( ids )
        call('creative').delete( @auth, ids )
      end

      def enable_creative( ids )
        call('creative').enable(@auth,ids)
      end

      def pause_creative( ids )
        call('creative').pause(@auth,ids)
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

