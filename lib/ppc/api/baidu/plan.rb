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
          ids = [ ids ] unless ids.is_a? Array
          body = { campaignIds: ids, campaignFields: PlanType.values}
          response = request(auth,Service,'getCampaign',body)
          return process( response, 'campaignType' ){ |x|reverse_type(x)[0] }
        end

        def self.all( auth )
          body = { campaignIds: nil, campaignFields: PlanType.values}
          response = request(auth,Service,'getCampaign',body)
          return process( response, 'campaignType' ){ |x|reverse_type(x) }
        end

        def self.ids( auth )
          body = { campaignIds: nil, campaignFields: ["campaignId"]}
          response = request(auth,Service,'getCampaign',body)
          return process( response, 'campaignIds' ){ |x|reverse_type(x) }
        end

        def self.get( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = { campaignIds: ids, campaignFields: PlanType.values}
          response = request(auth,Service,'getCampaign',body)
          return process( response, 'campaignType' ){ |x| reverse_type(x)}
        end

        def self.add( auth, plans )
          campaigntypes = make_type( plans )
          body = { campaignTypes: campaigntypes.merge(isDynamicCreative: param[:is_dynamic] || true) }
          response = request( auth, Service, 'addCampaign', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.update(auth,plans )
          campaigntypes = make_type( plans )
          body = { campaignTypes: campaigntypes.merge(isDynamicCreative: param[:is_dynamic] || true) }
          response = request( auth, Service, 'updateCampaign', body)
          process( response, 'campaignTypes' ){ |x| reverse_type(x) }
        end

        def self.delete(auth, ids )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          response = request( auth, Service, 'deleteCampaign', body)
          process( response, 'result' ){ |x| x }
        end
       
      end # Service
    end # baidu
  end # API
end # PPC
