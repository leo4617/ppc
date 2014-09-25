module PPC
  class Baidu
    class Plan < ::PPC::Baidu
      def initialize(params = {})
        params[:service] = 'Campaign'
        @se_id = params[:se_id]
        super(params)
      end

      def all(params = {})
        params[:plan_ids] = [@se_id]
        download(params)
      end

      def plans
        request('getAllCampaign')['campaignTypes']
      end

      def ids
        request('getAllCampaignId')['campaignIds']
      end

      #add one or more plans
      def add(plans)
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
        response = request('addCampaign',options)['campaignTypes']
        if single
          response.first
        else
          response
        end
      end

      def update_by_id(id,params = {})
        params['campaignId'] = id
        options = {campaignTypes: [params]}
        request('updateCampaign',options)['campaignTypes']
      end

      def update(plans)
        options = {campaignTypes: plans}
        request('updateCampaign',options)['campaignTypes']
      end

      def delete(ids)
        ids = [ids] unless ids.class == Array
        options = {campaignIds: ids}
        request('deleteCampaign',options)['result'] == 1
      end
    end
  end
end
