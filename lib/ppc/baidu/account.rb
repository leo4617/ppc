module PPC
  module Baidu
    class Account
      Service = 'Account'
      include ::PPC
      include ::PPC::Baidu

      ##########################plan#####################
      def plans
        request('Campaign','getAllCampaign')['campaignTypes']
      end

      def get_plan_by_id(ids)
        if ids.class != Array
          ids = [ids]
          single = true
        end

        options = {campaignIds: ids}
        response = request('Campaign','getCampaignByCampaignId',options)['campaignTypes']

        if single
          response.first
        else
          response
        end
      end

      def plan_ids
        request('Campaign','getAllCampaignId')['campaignIds']
      end

      def update_plan_by_id(id,params = {})
        params['campaignId'] = id
        options = {campaignTypes: [params]}
        request('Campaign','updateCampaign',options)['campaignTypes']
      end

      #add one or more plans
      def add_plan(plans)
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
        response = request('Campaign','addCampaign',options)['campaignTypes']
        if single
          response.first
        else
          response
        end
      end

      def update_plans(plans)
        options = {campaignTypes: plans}
        request('Campaign','updateCampaign',options)['campaignTypes']
      end

      def delete_plan_by_id(ids)
        ids = [ids] unless ids.class == Array
        options = {campaignIds: ids}
        request('Campaign','deleteCampaign',options)['result'] == 1
      end
      ##########################plan#####################

      def info
        request(Service,'getAccountInfo')['accountInfoType']#[:envelope][:body][:get_account_info_response][:account_info_type]
      end

      def all(params = {})
        download(params)
      end

      def update( params = {} )
        """
        update account info
        @ params : account_info_type
        @return : account info_type
        """
        info = {
          accountInfoType: {
            budgetType:              params[:budget_type] ,
            budget:                  params[:budget],
            regionTarget:            params[:region],
            excludeIp:               params[:excludeip] ,
            isDynamicCreative:       params[:isdynamic],
            dynamicCreativeParam:    params[:creativeparam]
          }
        }
        # delete null symbol
        info[:accountInfoType].each{
          |pair|
          key, value = pair
          info[:accountInfoType].delete(key) if value == nil
        }

        request(Service,'updateAccountInfo', info)['accountInfoType']
      end


      def query_report(params = {})
        report = ::PPC::Baidu::Report.new({username: @username, password: @password, token: @token, debug: @debug})

        begin
          @file_id = report.file_id_of_query(params)
          print_debug(@file_id,'file_id') if @debug

          loop do
            state = report.state(@file_id)
            raise "invalid file state: #{state}" unless %w(1 2 3 null).include? state
            break if state == '3'
            print_debug(state,'file_id.state') if @debug
            sleep 3
          end

          url = report.path(@file_id)
          open(url).read.force_encoding('gb18030').encode('utf-8')
        rescue Exception => e
          raise ReportException.new(@file_id,report,e)
        end
      end

      def cost_report(params = {})
        report = ::PPC::Baidu::Report.new({username: @username, password: @password, token: @token, debug: @debug})
        begin
          @file_id = report.file_id_of_cost(params)
          print_debug(@file_id,'file_id') if @debug

          loop do
            state = report.state(@file_id)
            raise "invalid file state: #{state}" unless %w(1 2 3 null).include? state
            break if state == '3'
            print_debug(state,'file_id.state') if @debug
            sleep 3
          end

          url = report.path(@file_id)
          open(url).read.force_encoding('gb18030').encode('utf-8')
        rescue Exception => e
          raise ReportException.new(@file_id,report,e)
        end
      end

    end
  end
end
