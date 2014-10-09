module PPC
  module Baidu
    module Account
      include ::PPC::Baidu
      Service = 'Account'

      def info(auth)
        request(auth,Service,'getAccountInfo')['accountInfoType']
      end

      def update(auth, params = {} )
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
        # info[:accountInfoType].each do |pair|
        #   key, value = pair
        #   info[:accountInfoType].delete(key) if value == nil
        # end

        request(auth,Service,'updateAccountInfo', info)['accountInfoType']
      end


      # def query_report(params = {})
      #   report = ::PPC::Baidu::Report.new({username: @username, password: @password, token: @token, debug: @debug})

      #   begin
      #     @file_id = report.file_id_of_query(params)
      #     print_debug(@file_id,'file_id') if @debug

      #     loop do
      #       state = report.state(@file_id)
      #       raise "invalid file state: #{state}" unless %w(1 2 3 null).include? state
      #       break if state == '3'
      #       print_debug(state,'file_id.state') if @debug
      #       sleep 3
      #     end

      #     url = report.path(@file_id)
      #     open(url).read.force_encoding('gb18030').encode('utf-8')
      #   rescue Exception => e
      #     raise ReportException.new(@file_id,report,e)
      #   end
      # end

      # def cost_report(params = {})
      #   report = ::PPC::Baidu::Report.new({username: @username, password: @password, token: @token, debug: @debug})
      #   begin
      #     @file_id = report.file_id_of_cost(params)
      #     print_debug(@file_id,'file_id') if @debug

      #     loop do
      #       state = report.state(@file_id)
      #       raise "invalid file state: #{state}" unless %w(1 2 3 null).include? state
      #       break if state == '3'
      #       print_debug(state,'file_id.state') if @debug
      #       sleep 3
      #     end

      #     url = report.path(@file_id)
      #     open(url).read.force_encoding('gb18030').encode('utf-8')
      #   rescue Exception => e
      #     raise ReportException.new(@file_id,report,e)
      #   end
      # end

    end
  end
end
