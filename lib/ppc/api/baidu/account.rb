module PPC
  module API
    class Baidu
      class Account< Baidu
        Service = 'Account'

        def self.info(auth, test = false)
          response = request(auth,Service,'getAccountInfo'  )
          return response if test else process( response, 'accountInfoType'){ |x|reverse_info_type(x) }
        end

        def self.update(auth, param = {}, test = false)
          """
          update account info
          @ params : account_info_type
          @return : account info_type
          """
          infoType = make_info_type( param )
          body = { accountInfoType: infoType }
          response = request(auth,Service,'updateAccountInfo', body)
          return response if test else process( response, 'accountInfoType' ){ |x|reverse_info_type(x) }
        end

        private 
        def self.make_info_type( param )
          infoType = {}
          infoType[:budgetType]                      =    param[:budget_type]       if    param[:budget_type] 
          infoType[:budget]                               =   param[:budget]                 if    param[:budget]
          infoType[:regionTarget]                     =   param[:region]                  if    param[:region]
          infoType[:excludeIp]                          =   param[:exclude_ip]          if    param[:exclude_ip]  
          infoType[:isDynamicCreative]           =  param[:isdynamic]           if    param[:isdynamic]
          infoType[:dynamicCreativeParam]  = param[:dynamic_param]  if    param[:dynamic_param]
          return infoType
        end

        def self.reverse_info_type( infotype )
          account_api = {}
          account_api[:id]                          = infotype['userid']                               if  infotype['userid']  
          account_api[:balance]               = infotype['balance']                             if infotype['balance'] 
          account_api[:cost]                      = infotype['cost']                                    if  infotype['cost']  
          account_api[:payment]             = infotype['payment']                           if  infotype['payment']
          account_api[:status]                  = infotype['userStat']                            if  infotype['userStat']
          account_api[:budget_type]       =  infotype['budgetType']                     if  infotype['budgetType'] 
          account_api[:budget]                = infotype['budget']                               if infotype['budget']
          account_api[:region]                 = infotype['regionTarget']                     if  infotype['regionTarget']
          account_api[:exclude_ip]          =  infotype['excludeIp']                         if infotype['excludeIp']  
          account_api[:isdynamic]           = infotype['isDynamicCreative']          if infotype['isDynamicCreative']
          account_api[:dynamic_param] = infotype['dynamicCreativeParam'] if infotype['dynamicCreativeParam']
          account_api[:open_domains]   = infotype['openDomains']                  if infotype['openDomains']
          account_api[:reg_domain]         = infotype['regDomain']                       if infotype['regDomain']
          account_api[:offline_time]         = infotype['budgetOfflineTime']          if infotype['budgetOfflineTime']
          account_api[:weekly_budget]     = infotype['weeklyBudget']                   if infotype['weeklyBudget']
          account_api[:opt]                         = infotype['opt']                                     if infotype['opt']

          return account_api
        end

      end
    end
  end
end
