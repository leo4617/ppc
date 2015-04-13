module PPC
  module API
    class Sm
      class Plan < Sm
        Service = 'campaign'

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
                [:pause,:pause],
                [:status,:status]
               ]

        def self.all( auth )
          response = request( auth, Service, 'getAllCampaign' )
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.ids( auth )
          response = request( auth, Service, 'getAllCampaignID' )
          process( response, 'campaignIds' ){ |x| x }
        end

        def self.get( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = { campaignIds: ids }
          response = request( auth, Service, 'getCampaignByCampaignId', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.add( auth, plans )
          campaign_types = make_type( plans )
          body = { campaignTypes: campaign_types }
          response = request( auth, Service, 'addCampaign', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.update(auth,plans )
          campaign_types = make_type( plans )
          body = { campaignTypes: campaign_types }
          response = request( auth, Service, 'updateCampaign', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.delete(auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = { campaignIds: ids }
          response = request( auth, Service, 'deleteCampaign', body, "delete")
          process( response, 'result' ){ |x| x }
        end
       
      end # Service
    end # baidu
  end # API
end # PPC
