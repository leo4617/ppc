module PPC
  module Baidu
    module Plan
      include ::PPC::Baidu
      Service = 'Campaign'

      def self.all(auth)
        request(auth,Service,'getAllCampaign')['campaignTypes']
      end

      def self.ids(auth)
        request(auth,Service,'getAllCampaignId')['campaignIds']
      end

      def self.get(auth,ids)
        if ids.class != Array
          ids = [ids]
          single = true
        end

        options = {campaignIds: ids}
        response = request(Service,'getCampaignByCampaignId',options)['campaignTypes']

        if single
          response.first
        else
          response
        end
      end

      #add one or more plans
      def self.add(auth,plans)
        if plans.class == Hash
          plans = [plans]
          single = true
        end
        campaignTypes = []

        plans.each do |plan|
          campaignTypes << {
            campaignName: plan[:name],
            negativeWords: plan[:negative],
            exactNegativeWords: plan[:exact_negative]
          }
        end

        options = {campaignTypes:  campaignTypes}
        response = request(auth,'Campaign','addCampaign',options)['campaignTypes']
        if single
          response.first
        else
          response
        end
      end

      def self.update(auth,plans)
        plans = [plans] unless plan.is_a? Array

        options = []
        plans.each do |plan|
          option = {
            campaignId:             plan[:id]
            campaignName:           plan[:name]                 || nil
            budget:                 plan[:budget]               || nil
            regionTarget:           plan[:region]               || nil
            excludeIp:              plan[:ip]                   || nil
            negativeWords:          plan[:negative]             || nil
            exactNegativeWords:     plan[:exact_negative]       || nil
            schedule:               plan[:schedule]             || nil
            budgetOfflineTime:      plan[:budget_offline_time]  || nil
            showProb:               plan[:show_prob]            || nil
            device:                 plan[:device]               || nil
            priceRatio:             plan[:price_ratio]          || nil
            pause:                  plan[:pause]                || nil
            status:                 plan[:status]               || nil
          }
          options << option
        end
        options = {campaignTypes: options}
        request(auth,Service,'updateCampaign',options)['campaignTypes']
      end

      def self.delete(ids)
        ids = [ids] unless ids.class == Array
        options = {campaignIds: ids}
        request(auth,'Campaign','deleteCampaign',options)['result'] == 1
      end
    end
  end
end
