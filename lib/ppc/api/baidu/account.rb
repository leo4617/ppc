module PPC
  module API
    class Baidu
      class Account< Baidu
        Service = 'Account'

        AccountInfoType = {
          id:                   :userId,
          balance:              :balance,
          pc_balance:           :pcBalance,
          mobile_balance:       :mobileBalance,
          cost:                 :cost,
          payment:              :payment,
          status:               :userStat,
          budget_type:          :budgetType,
          budget:               :budget,
          region:               :regionTarget,
          exclude_ip:           :excludeIp,
          isdynamic:            :isDynamicCreative,
          isdynamictagsublink:  :isDynamicTagSublink,
          isdynamichotredirect: :isDynamicHotRedirect,
          isdynamictitle:       :isDynamicTitle,
          dynamic_param:        :dynamicCreativeParam,
          open_domains:         :openDomains,
          reg_domain:           :regDomain,
          offline_time:         :budgetOfflineTime,
          weekly_budget:        :weeklyBudget,
          opt:                  :opt,
        }
        @map = AccountInfoType

        def self.info( auth )
          body = {:accountFields => AccountInfoType.values}
          response = request(auth,Service,'getAccountInfo',body)
          return process( response, 'accountInfoType' ){ |x|reverse_type(x)[0] }
        end

        def self.update(auth, param = {} )
          """
          update account info
          @ params : account_info_type
          @return : account info_type
          """
          # for account service, there is not bulk operation
          infoType = make_type( param )[0]
          body = { accountInfo: infoType }
          response = request(auth,Service,'updateAccountInfo', body)
          return process( response, 'accountInfoType' ){ |x|reverse_type(x)[0] }
        end

      end
    end
  end
end
