module PPC
  module API
    module Baidu
      module Plan
        include ::PPC::API::Baidu
        Service = 'Campaign'

        def self.get_all( auth )
          request( auth, Service, 'getAllCampaign' )['campaignTypes']
        end

        def self.get_all_id( auth )
          request( auth, Service, 'getAllCampaignId' )['campaignIds']
        end

        def self.get_by_id( auth, ids )
          ids = [ ids ] unless ids.is_a ? Array
          body = { campaignIds: ids }
          request( Service, 'getCampaignByCampaignId', body)['campaignTypes']
        end

        def self.add( auth,plans )
          plans = [ plans ]unless plans.is_a ? Array
          campaigntypes = []

          plans.each do |plan|
            campaigntypes << {
              campaignName: plan[:name],
              negativeWords: plan[:negative],
              exactNegativeWords: plan[:exact_negative]
            }
          end

          body = {campaignTypes:  campaigntypes}
          request( auth, Service, 'addCampaign', body)['campaignTypes']
        end

        def self.update(auth,plans)
          plans = [plans] unless plan.is_a? Array
          campaigntypes = []

          plans.each do |plan|
            campaigntype = {}
            
            campaigntype[:campaignId]                    plan[:id]                                  if    plan[:id]  
            campaigntype[:campaignName]             plan[:name]                           if    plan[:name]
            campaigntype[:budget]                             plan[:budget]                        if    plan[:budget]
            campaigntype[:regionTarget]                   plan[:region]                         if    plan[:region] 
            campaigntype[:excludeIp]                        plan[:ip]                                  if    plan[:ip]
            campaigntype[:negativeWords]               plan[:negative]                      if    plan[:negative]  
            campaigntype[:exactNegativeWords]     plan[:exact_negative]           if    plan[:exact_negative]
            campaigntype[:schedule]                          plan[:schedule]                      if    plan[:schedule]
            campaigntype[:budgetOfflineTime]         plan[:budget_offline_time]  if    plan[:budget_offline_time]
            campaigntype[:showProb]                        plan[:show_prob]                  if    plan[:show_prob]
            campaigntype[:device]                               plan[:device]                          if    plan[:device] 
            campaigntype[:priceRatio]                        plan[:price_ratio]                   if    plan[:price_ratio]
            campaigntype[:pause]                                plan[:pause]                           if    plan[:pause]

            campaigntypes << campaigntype
          end
          body = { campaignTypes: campaigntypes }
          request( auth, Service, 'updateCampaign', body)['campaignTypes']
        end

        def self.delete(ids)
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          request( auth, 'Campaign', 'deleteCampaign', body)['result'] == 1
        end
        
      end # Service
    end # baidu
  end # API
end # PPC