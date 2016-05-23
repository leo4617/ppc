module PPC
  module API
    class Sogou
      class Plan< Sogou
        Service = 'CpcPlan'

        PlanType = {
          id:                   :cpcPlanId,
          name:                 :cpcPlanName,
          budget:               :budget, 
          region:               :regions,
          ip:                   :excludeIps,
          negative:             :negativeWords,
          exact_negative:       :exactNegativeWords,
          schedule:             :schedule, 
          budget_offline_time:  :budgetOfflineTime,
          show_prob:            :showProb,  
          join_union:           :joinUnion,
          device:               :device,
          price_ratio:          :mobilePriceRate,
          pause:                :pause,
          status:               :status,
          "id" =>               :cpc_plan_id,
          "name" =>             :cpc_plan_name,
        }
        @map = PlanType

        def self.all( auth )
          response = request( auth, Service, 'getAllCpcPlan' )
          process( response, 'cpcPlanTypes' ){ |x| reverse_type(x) }
        end

        def self.ids( auth )
          response = request( auth, Service, 'getAllCpcPlanId' )
          process( response, 'cpcPlanIds' ){ |x| x }
        end

        def self.get( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcPlanIds: ids }
          response = request( auth, Service, 'getCpcPlanByCpcPlanId', body)
          process( response, 'cpcPlanTypes' ){ |x| reverse_type(x) }
        end

        def self.add( auth, plans )
          cpcPlanTypes = make_type( plans )
          body = { cpcPlanTypes: cpcPlanTypes }
          response = request( auth, Service, 'addCpcPlan', body)
          process( response, 'cpcPlanTypes' ){ |x| reverse_type(x) }
        end

        def self.update( auth, plans )
          cpcPlanTypes = make_type( plans )
          body = { cpcPlanTypes: cpcPlanTypes }
          response = request( auth, Service, 'updateCpcPlan', body)
          process( response, 'cpcPlanTypes' ){ |x| reverse_type(x) }
        end

        def self.delete(auth, ids )
          ids = [ ids ] unless ids.class == Array
          body = { cpcPlanIds: ids }
          response = request( auth, Service, 'deleteCpcPlan', body)
          process( response, '' ){ |x| x }
        end
       
      end # Service
    end # baidu
  end # API
end # PP
