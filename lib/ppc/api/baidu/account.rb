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
        body = {
          accountInfoType: {
            budgetType:                         param[:budget_type]       if    param[:budget_type] 
            budget:                                 param[:budget]                 if    param[:budget]
            regionTarget:                       param[:region]                  if    param[:region]
            excludeIp:                             param[:exclude_ip]          if    param[:exclude_ip]  
            isDynamicCreative:             param[:isdynamic]           if    param[:isdynamic]
            dynamicCreativeParam:    param[:creative_param]  if    param[:creative_param]
          }
        }
        request(auth,Service,'updateAccountInfo', body)['accountInfoType']
      end

    end
  end
end
