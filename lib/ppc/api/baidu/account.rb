module PPC
  module API
    module Baidu
      module Account
        Service = 'Account'

        def self.info(auth, test = false)
          response = request(auth,Service,'getAccountInfo'  )
          return response if test else response['body']['accountInfoType']
        end

        def self.update(auth, param = {}, test = false)
          """
          update account info
          @ params : account_info_type
          @return : account info_type
          """
          infoType = {}

          infoType[:budgetType]                      =    param[:budget_type]       if    param[:budget_type] 
          infoType[:budget]                               =   param[:budget]                 if    param[:budget]
          infoType[:regionTarget]                     =   param[:region]                  if    param[:region]
          infoType[:excludeIp]                          =   param[:exclude_ip]          if    param[:exclude_ip]  
          infoType[:isDynamicCreative]           =  param[:isdynamic]           if    param[:isdynamic]
          infoType[:dynamicCreativeParam]  = param[:creative_param]  if    param[:creative_param]
    
          body = { accountInfoType: infoType }
          response = request(auth,Service,'updateAccountInfo', body)
          return response if test else response['body']['accountInfoType']
        end

        # introduce request to this namespace
        def self.request(auth, service, method, params = {} )
          ::PPC::API::Baidu::request(auth, service, method, params )
        end

      end
    end
  end
end
