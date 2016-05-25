module PPC
  module API
    class Sm
      class Plan < Sm
        Service = 'campaign'

        PlanType = {
          id:                   :campaignId,
          name:                 :campaignName,
          budget:               :budget,
          region:               :regionTarget,
          ip:                   :excludeIp,
          negative:             :negativeWords,
          exact_negative:       :exactNegativeWords,
          schedule:             :schedule,
          budget_offline_time:  :budgetOfflineTime,
          show_prob:            :showProb,  
          pause:                :pause,
          status:               :status,
        }
        @map = PlanType

        def self.info( auth, ids )
          response = request( auth, Service, 'getCampaignByCampaignId', {campaignIds: ids})
          process( response, 'campaignTypes' ){ |x| reverse_type(x)[0] }
        end

        def self.all( auth )
          response = request( auth, Service, 'getAllCampaign' )
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.ids( auth )
          response = request( auth, Service, 'getAllCampaignID' )
          process( response, 'campaignIds' ){ |x| x }
        end

        def self.get( auth, ids )
          response = request( auth, Service, 'getCampaignByCampaignId', {campaignIds: ids})
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.add( auth, plans )
          body = { campaignTypes: make_type( plans ) }
          response = request( auth, Service, 'addCampaign', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.update( auth, plans )
          body = { campaignTypes: make_type( plans ) }
          response = request( auth, Service, 'updateCampaign', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids )
          response = request( auth, Service, 'deleteCampaign', {campaignIds: ids}, "delete")
          process( response, 'result' ){ |x| x }
        end

        def self.enable( auth, ids )
          plans = ids.map{|id| {id: id, pause: false} }
          self.update( auth, plans )
        end

        def self.pause( auth, ids )
          plans = ids.map{|id| {id: id, pause: true} }
          self.update( auth, plans )
        end
       
      end # Service
    end # baidu
  end # API
end # PPC
