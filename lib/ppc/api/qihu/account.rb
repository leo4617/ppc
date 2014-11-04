# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Account < Qihu
        Service = 'account'

        @map = [
                        [ :id, :uid ],
                        [ :name, :userName ],
                        [ :email, :email],
                        [ :company, :companyName],
                        [ :industry1, :industry1],
                        [ :industry2, :industry2],
                        [ :balance :balance],
                        [ :budget, :budget],
                        [ :resources, :resources],
                        [ :open_domains, :allowDomain]
                      ]
        
        def self.info( auth )
          response = request( auth, Service, 'getInfo' )
          process( response, 'account_getInfo_response' ){ |x| reverse _type( x )}
        end

        def self.update( auth, params )
          # response = resquest( auth, Service, '')
        end

        def self.get_all_object( auth, ids )
          #文档上面写的输入类型是String？
          body = { 'idList' =>  ids }
          response = request( auth, Service, 'getAllObjects' )
          process( response, 'account_getAllObjects_response' ){ |x| x }
        end

        def self.get_file_state( auth, id )
          body = { 'fileId' => id }
          response = request( auth, Service, 'getAllObjects' , body )
          process( response, 'account_getFileState_response' ){ |x| x }
        end

        def self.get_exclude_ip( auth )
          response = request( auth, Service, 'getExcludeIp' )
          process( response, 'account_getExcludeIp_response' ){ |x| x['excludeIpList']}
        end

        def ids( auth )
          response = request( auth, Service, 'getCampaignIdList' )
          process( response, 'account_getCampaignIdList_response' ){ |x| x['item'] }
        end 

        private
        def self.update_budget( auth, budget )
          response = request( auth, Service, 'updateBudget', { budget:budget })
          process( response, 'account_updateBudget_response' ){ | x | x }
        end

        private
        def self.update_exclude_ip( auth, ips )
          ips = [ips] unless ips.is_a? Array
          response = request( auth, Service, 'updateExcludeIp', { excludeIpList: ips } )
          process( response, 'account_updateExcludeIp_response' ){ | x | x }
        end

      end
    end
  end
end