# -*- coding:utf-8 -*-
require 'json'
module PPC
  module API
    class Qihu
      class Account < Qihu
        Service = 'account'

        AccountType = {
          id:           :uid,
          name:         :userName,
          email:        :email,
          company:      :companyName,
          industry1:    :industry1,
          industry2:    :industry2,
          balance:      :balance,
          budget:       :budget,
          resources:    :resources,
          open_domains: :allowDomain,
        }
        @map = AccountType
                
        
        def self.info( auth )
          response = request( auth, Service, 'getInfo' )
          process( response, '' ){ |x| reverse_type( x )[0]}
        end

        def self.update( auth, params )
          '''
          对奇虎两个update的在封装。如果所有操作成功，succ为true，否则为false
          failure中以字符串方式返回失败的操作
          '''
          result = {
            succ:     true,
            failure:  [],
            result:   [],
          }

          if params[:budget]
            budget_result = update_budget( auth, params[:budget] )
            result[:succ] = result[:succ] && budget_result[:succ]
            result[:failure] << 'budget' unless budget_result[:succ]
          end

          if params[:exclude_ip]
            ip_result = update_exclude_ip( auth, params[:exclude_ip] )
            result[:succ] = result[:succ] && ip_result[:succ]
            result[:failure] << 'exclude_ip' unless budget_result[:succ]
          end

          result
        end

        def self.get_all_object( auth, ids )
          #文档上面写的输入类型是String？
          response = request( auth, Service, 'getAllObjects', { 'idList' =>  ids } )
          process( response, 'account_getAllObjects_response' ){ |x| x }
        end

        def self.get_file_state( auth, id )
          response = request( auth, Service, 'getAllObjects' , { 'fileId' => id } )
          process( response, 'account_getFileState_response' ){ |x| x }
        end

        def self.get_exclude_ip( auth )
          response = request( auth, Service, 'getExcludeIp' )
          process( response, 'excludeIpList' ){ |x| x}
        end

        private
        def self.update_budget( auth, budget )
          response = request( auth, Service, 'updateBudget', { budget: budget })
          process( response, 'affectedRecords' ){ | x | x.to_i==1 ? 'success' : 'failure' }
        end

        private
        def self.update_exclude_ip( auth, ips )
          response = request( auth, Service, 'updateExcludeIp', { excludeIpList: ips.map(&:to_s) } )
          process( response, '' ){|x| x}
        end

      end
    end
  end
end
