module PPC
  module API
    module Baidu
      module Plan
        include ::PPC::API::Baidu
        Service = 'Campaign'

        # introduce request to this namespace
        def self.request(auth, service, method, params = {} )
          ::PPC::API::Baidu::request(auth, service, method, params )
        end

        def self.all( auth, test = false )
          response = request( auth, Service, 'getAllCampaign' )
          return response if test else response['body']['campaignTypes']
        end

        def self.all_id( auth, test = false )
          response = request( auth, Service, 'getAllCampaignId' )
          return response if test else response['body']['campaignIds']
        end

        def self.get_by_id( auth, ids, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { campaignIds: ids }

          response = request( auth, Service, 'getCampaignByCampaignId', body)
          return response if test else response['body']['campaignTypes']
        end

        def self.add( auth, plans, test = false )
          campaigntypes = make_campaigntype( plans )

          body = { campaignTypes: campaigntypes }

          response = request( auth, Service, 'addCampaign', body)
          return response if test else response['body']['campaignTypes']
        end

        def self.update(auth,plans, test = false )
          campaigntypes = make_campaigntype( plans )
          body = { campaignTypes: campaigntypes }
          response = request( auth, Service, 'updateCampaign', body)
          return response if test else response['body']['campaignTypes']
        end

        def self.delete(auth, ids, test = false )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          response = request( auth, 'Campaign', 'deleteCampaign', body)
          return response if test else response['body']['result']
        end


        def self.make_campaigntype( plans )
          plans = [plans] unless plans.is_a? Array

          campaigntypes = []
          plans.each do |plan|
            campaigntype = {}
            
            campaigntype[:campaignId]                =   plan[:id]                                  if    plan[:id]  
            campaigntype[:campaignName]         =   plan[:name]                           if    plan[:name]
            campaigntype[:budget]                         =   plan[:budget]                        if    plan[:budget]
            campaigntype[:regionTarget]               =   plan[:region]                         if    plan[:region] 
            campaigntype[:excludeIp]                    =   plan[:ip]                                  if    plan[:ip]
            campaigntype[:negativeWords]           =   plan[:negative]                      if    plan[:negative]  
            campaigntype[:exactNegativeWords] =   plan[:exact_negative]           if    plan[:exact_negative]
            campaigntype[:schedule]                      =   plan[:schedule]                      if    plan[:schedule]
            campaigntype[:budgetOfflineTime]     =   plan[:budget_offline_time]  if    plan[:budget_offline_time]
            campaigntype[:showProb]                    =   plan[:show_prob]                  if    plan[:show_prob]
            campaigntype[:device]                           =   plan[:device]                          if    plan[:device] 
            campaigntype[:priceRatio]                    =   plan[:price_ratio]                   if    plan[:price_ratio]
            campaigntype[:pause]                            =   plan[:pause]                           if    plan[:pause]

            campaigntypes << campaigntype
          end
          return campaigntypes
        end
       
      end # Service
    end # baidu
  end # API
end # PPC