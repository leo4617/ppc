module PPC
  module Baidu
    module Account
      include ::PPC::Baidu
      Service = 'Account'

      def info(auth)
        request(auth,Service,'getAccountInfo')['accountInfoType']
      end

      def update(auth, param = {} )
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
        request(auth,Service,'updateAccountInfo', body)['accountInfoType']
      end

    end
  end
end
