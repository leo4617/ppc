module PPC
  module Operation

    attr_accessor :id
    
    def initialize( params )
      
      if params[:se] == nil
        raise 'please specific a search engine'
      else 
        @se = params[:se]
      end
      @id = params[:id]
      @auth = {
        username: params[:username],
        password: params[:password],
        # 在qihu360的api中，apikey就是auth[:token]
        token:    params[:token]
      }
      # add support for qihu360
      if @se == 'qihu'
        raise "you are using qihu service, please enter api_key" if params[:api_key].nil?
        @auth[:api_key] = params[:api_key]
      end
      if @se == 'qihu' && params[:token].nil? 
        raise "you are using qihu service, please enter api_secret" if params[:api_secret].nil?
        @auth[:api_secret] = params[:api_secret]
        @auth[:token] = qihu_refresh_token
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

    # ++++++++ #
    # Lazy Code #
    # ++++++++ #

    # helper fucntion
    def get_obj( ids, service )
        '''
        Return service object. 
        Providing single id, return single object.
        Providing multiple ids, return Array of objects
        '''
        class_obj =  eval "::PPC::Opeartion::#{service.capitalize}"
        param = @auth
        param[:se] = @se
        objs = []

        ids.each do |id|
          param[:id] = id
          objs << class_obj.new( param )
        end

        return objs.length == 1 ? objs[0] : objs 
    end

    # +++++ Plan opeartion funcitons +++++ #
    module Plan_operation
      def get_plan( ids )
        ::PPC::Opeartion::get_obj( ids, 'plan')
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
    end

    # +++++ Group opeartion funcitons +++++ #
    module Group_operation
      def get_group( ids )
        ::PPC::Opeartion::get_obj( ids, 'group')
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
    end

    # +++++ Keyword opeartion funcitons +++++ #
    module Keyword_operation
      def get_keyword( ids )
        ::PPC::Opeartion::get_obj( ids, 'keyword')
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
    end

    # +++++ Creative opeartion funcitons +++++ #
    module Creative_operation
      def get_creative( ids )
        ::PPC::Opeartion::get_obj( ids, 'creative')
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

