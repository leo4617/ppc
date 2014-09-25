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

      def ids
        request('getAllCampaignId')['campaignIds']
      end

      def add(params = {})
        options = {
          campaignTypes:  [
            campaignName: params[:name],
            negativeWords: params[:negative],
            exactNegativeWords: params[:exact_negative]
          ]}
        request('addCampaign',options)['campaignTypes'].first
      end

      def delete(ids)
        ids = [ids] unless ids.class = Array
        options = {campaignIds: ids}
        request('deleteCampaign',options)
      end
    end
  end
end
