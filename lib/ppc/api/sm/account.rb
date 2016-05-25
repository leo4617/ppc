module PPC
  module API
    class Sm
      class Account < Sm
        Service = 'account'

        AccountType = {
          id:             :userId,
          name:           :userName,
          balance:        :balance,
          cost:           :cost,
          payment:        :payment,
          budget_type:    :budgetType,
          budget:         :budget,
          region:         :regionTarget,
          exclude_ip:     :excludeIp,
          open_domains:   :openDomains,
          reg_domain:     :regDomain,
          offline_time:   :budgetOfflineTime,
          weekly_budget:  :weeklyBudget,
          status:         :userStat,
        }
        @map = AccountType

        def self.info( auth )
          response = request(auth, Service, 'getAccount', {requestData: ["account_all"]})
          process( response, 'accountInfoType' ){ |x|reverse_type(x)[0] }
        end

        def self.update(auth, param = {} )
          """
          update account info
          @ params : account_info_type
          @return : account info_type
          """
          # for account service, there is not bulk operation
          body = { accountInfoType: make_type( param )[0] }
          response = request(auth, Service, 'updateAccount', body)
          process( response, 'accountInfoType' ){ |x|reverse_type(x)[0] }
        end

      end
    end
  end
end
