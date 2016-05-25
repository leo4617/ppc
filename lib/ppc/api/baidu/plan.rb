module PPC
  module API
    class Baidu
      class Plan< Baidu
        Service = 'Campaign'

        PlanType = {
          id:                   :campaignId,
          name:                 :campaignName,
          budget:               :budget,
          region:               :regionTarget,
          negative:             :negativeWords,
          exact_negative:       :exactNegativeWords,
          schedule:             :schedule,
          budget_offline_time:  :budgetOfflineTime,
          show_prob:            :showProb,
          device:               :device,
          price_ratio:          :priceRatio,
          is_dynamic:           :isDynamicCreative,
          pause:                :pause,
          status:               :status,
          rmkt_status:          :rmktStatus,
          type:                 :campaignType,
          isdynamictagsublink:  :isDynamicTagSublink,
          isdynamichotredirect: :isDynamicHotRedirect,
          isdynamictitle:       :isDynamicTitle,
          rmkt_price_ratio:     :rmktPriceRatio,
        }
        @map = PlanType

        def self.info( auth, ids )
          body = { campaignIds: ids, campaignFields: PlanType.values}
          response = request(auth,Service,'getCampaign',body)
          process( response, 'campaignType' ){ |x|reverse_type(x)[0] }
        end

        def self.all( auth )
          body = { campaignIds: nil, campaignFields: PlanType.values}
          response = request(auth,Service,'getCampaign',body)
          process( response, 'campaignTypes' ){ |x|reverse_type(x) }
        end

        def self.ids( auth )
          body = { campaignIds: nil, campaignFields: ["campaignId"]}
          response = request(auth,Service,'getCampaign',body)
          process( response, 'campaignIds' ){ |x|reverse_type(x) }
        end

        def self.get( auth, ids )
          body = { campaignIds: ids, campaignFields: PlanType.values}
          response = request( auth, Service, 'getCampaign', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x)}
        end

        def self.add( auth, plans )
          body = { campaignTypes: make_type( plans ) }
          response = request( auth, Service, 'addCampaign', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.update(auth,plans )
          body = { campaignTypes: make_type( plans ) }
          response = request( auth, Service, 'updateCampaign', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.delete(auth, ids )
          response = request( auth, Service, 'deleteCampaign', {campaignIds: ids} )
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
