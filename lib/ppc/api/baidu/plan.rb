module PPC
  module API
    class Baidu
      class Plan< Baidu
        Service = 'Campaign'

        @map = [
                          [:id,:campaignId],
                          [:name,:campaignName],
                          [:budget,:budget], 
                          [:region,:regionTarget],
                          [:ip,:excludeIp] ,
                          [:negative,:negativeWords],
                          [:exact_negative,:exactNegativeWords],
                          [:schedule,:schedule], 
                          [:budget_offline_time,:budgetOfflineTime],
                          [:show_prob,:showProb],   
                          [:device,:device],
                          [:price_ratio,:priceRatio], 
                          [:pause,:pause],
                          [:status,:status],
                        ]

        def self.all( auth, debug = false )
          response = request( auth, Service, 'getAllCampaign' )
          process( response, 'campaignTypes' , debug ){ |x| reverse_type(x) }
        end

        def self.ids( auth, debug = false )
          response = request( auth, Service, 'getAllCampaignId' )
          process( response, 'campaignIds' , debug ){ |x| x }
        end

        def self.get( auth, ids, debug = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { campaignIds: ids }
          response = request( auth, Service, 'getCampaignByCampaignId', body)
          process( response, 'campaignTypes' , debug ){ |x| reverse_type(x) }
        end

        def self.add( auth, plans, debug = false )
          campaigntypes = make_type( plans )
          body = { campaignTypes: campaigntypes }
          response = request( auth, Service, 'addCampaign', body)
          process( response, 'campaignTypes' , debug ){ |x| reverse_type(x) }
        end

        def self.update(auth,plans, debug = false )
          campaigntypes = make_type( plans )
          body = { campaignTypes: campaigntypes }
          response = request( auth, Service, 'updateCampaign', body)
          process( response, 'campaignTypes' , debug ){ |x| reverse_type(x) }
        end

        def self.delete(auth, ids, debug = false )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
<<<<<<< HEAD
          response = request( auth, 'Campaign', 'deleteCampaign', body)
=======
          response = request( auth, Service, 'deleteCampaign', body)
>>>>>>> oop
          process( response, 'result' , debug ){ |x| x }
        end
       
      end # Service
    end # baidu
  end # API
end # PPC