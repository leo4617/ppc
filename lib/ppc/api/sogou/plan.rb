module PPC
  module API
    class Sogou
      class Plan< Sogou
        Service = 'CpcPlan'

        @map = [
                          [:id,:cpcPlanId],
                          [:name,:cpcPlanName],
                          [:budget,:budget], 
                          [:region,:regions],
                          [:ip,:excludeIps] ,
                          [:negative,:negativeWords],
                          [:exact_negative,:exactNegativeWords],
                          [:schedule,:schedule], 
                          [:budget_offline_time,:budgetOfflineTime],
                          [:show_prob,:showProb],   
                          [:join_union ,:joinUnion],
                          [:device,:device],
                          [:price_ratio,:mobilePriceRate ], 
                          [:pause,:pause],
                          [:status,:status],
                        ]

        def self.all( auth, debug = false )
          response = request( auth, Service, 'getAllCpcPlan' )
          process( response, 'cpcPlanTypes' , debug ){ |x| reverse_type(x) }
        end

        def self.ids( auth, debug = false )
          response = request( auth, Service, 'getAllCpcPlanId' )
          process( response, 'cpcPlanIds' , debug ){ |x| x }
        end

        def self.get( auth, ids, debug = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcPlanIds: ids }
          response = request( auth, Service, 'getCpcPlanByCpcPlanId', body)
          process( response, 'cpcPlanTypes' , debug ){ |x| reverse_type(x) }
        end

        def self.add( auth, plans, debug = false )
          cpcPlanTypes = make_type( plans )
          body = { cpcPlanTypes: cpcPlanTypes }
          response = request( auth, Service, 'addCpcPlan', body)
          process( response, 'cpcPlanTypes' , debug ){ |x| reverse_type(x) }
        end

        def self.update(auth,plans, debug = false )
          cpcPlanTypes = make_type( plans )
          body = { cpcPlanTypes: cpcPlanTypes }
          response = request( auth, Service, 'updateCpcPlan', body)
          process( response, 'cpcPlanTypes' , debug ){ |x| reverse_type(x) }
        end

        def self.delete(auth, ids, debug = false )
          ids = [ ids ] unless ids.class == Array
          body = { cpcPlanIds: ids }
          response = request( auth, Service, 'deleteCpcPlan', body)
          process( response, '' , debug ){ |x| x }
        end
       
      end # Service
    end # baidu
  end # API
end # PPC