module PPC
  module API
    class Sogou
      class Account < Sogou
        Service = 'Account'

        AccountType = {
          id:           :accountid,
          balance:      :balance,
          cost:         :total_cost,
          payment:      :total_pay,
          budget_type:  :type,
          budget:       :budget,
          region:       :regions,
          exclude_ip:   :excludeIps,
          open_domains: :domains,
          offline_time: :budgetOfflineTime,
          opt:          :opt,
        }
        @map = AccountType

        def self.info( auth )
          response = request(auth,Service,'getAccountInfo' )
          process( response, 'accountInfoType' ){ |x|reverse_type(x)[0] }
        end

        def self.update(auth, param = {})
          """
          update account info
          @ params : account_info_type
          @return : account info_type
          """
          # for account service, there is not bulk operation
          body = { accountInfoType: make_type( param )[0] }
          response = request(auth,Service,'updateAccountInfo', body)
          process( response, 'accountInfoType' ){ |x|reverse_type(x)[0] }
        end

      end
    end
  end
end
