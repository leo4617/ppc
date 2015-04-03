module PPC
  module API
    class Sm
      class Account < Sm
        Service = 'account'

        @map = [
                  [:id,:userId],
                  [:balance,:balance],
                  [:cost,:cost],
                  [:payment,:payment],
                  [:budget_type,:budgetType],
                  [:budget,:budget],
                  [:region,:regionTarget],
                  [:exclude_ip,:excludeIp],
                  [:open_domains,:openDomains],
                  [:reg_domain,:regDomain],
                  [:offline_time,:budgetOfflineTime],
                  [:weekly_budget,:weeklyBudget]
                ]

        def self.info( auth )
          response = request(auth, Service, 'getAccount', {requestData: ["account_all"]})
          p response
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
          body = { accountInfoType: infoType }
          response = request(auth, Service, 'updateAccount', body)
          return process( response, 'accountInfoType' ){ |x|reverse_type(x)[0] }
        end

      end
    end
  end
end
