module PPC
  module API
    module Baidu
      module Report
        include ::PPC::Baidu
        Service 'Report'
      
        # 需要用到的映射集合
        Type_map = { 'account' => 2, 'plan'=> 10, 'group'=> 11, 
                                              'keyword'=> 14, 'creative'=> 12, 'pair'=> 15, 
                                              'region'=> 3, 'wordid'=> 9 }
        Level_map = {  'account' => 2, 'plan' => 3, 'group' => 5, 
                                  'creative' => 7, 'keywordid' => 11, 'pair' => 12, 
                                  'wordid' => 6 }
        Device_map = { 'all' => 0, 'pc' => 1, 'mobile' => 2 }
        Unit_map = { 'day' => 5, 'week' => 4, 'month' => 3, 'year' => 1, 'hour' => 7 }

        def self.get_real_time( auth, params, type = :data )
          params = [ params ] unless params.is_a ? Array
          request = make_realtimetype(params)
          body = { realTimeRequestTypes:  request }
          response = request( auth, Service, 'getRealTimeData' ,body)

          response = case type
            when :data     :    response['realTimeResultTypes']
            when :query  :    response['realTimeQueryResultTypes']
            when :pair      :    response['realTimePairResultTypes']
          end
          
          return response                   
        end


        def self.get_id( auth, params )
          params = [ params ] unless params.is_a ? Array
          request = make_reporttype( params )
          body =  { realTimeRequestTypes:  request }
          request( auth, Service, 'getProfessionalReportId' ,body)['reportId']       
        end

        def self.get_status( auth, ids )
          ids = [ ids ] unless ids.is_a ? Array
          body = { reportId:  ids }
          request( auth, Service, 'getReportState' ,body)['isGenerated']      
        end

        def self.get_file_url( auth, ids )
          ids = [ ids ] unless ids.is_a ? Array
          body = { reportId:  ids }
          request( auth, Service, 'getReportFileUrl' ,body)['reportFilePath']       
        end

        private 
        def make_realtimerequest( params )
          '''
          make RealTimeRequestType
          没有封装关键字：attribute，order,statIds
          '''
          params = [ params ] unless params.is_a ? Array
          requesttypes = []
          params.each do  |param|
            requesttype = {}

            requesttype[:performanceData]   =     param[:fields]        ||     %w(click impression)
            requesttype[:reportType]               =     Type_map[ param[:type] ]          if  param[:type]  else 14
            requesttype[:levelOfDetails]          =     Level_map[  param[:level] ]        if param[:level] else  11
            requesttype[:statRange]                 =     Level_map[ param[:range] ]       if param[:range] else 11
            requesttype[:unitOfTime]               =     Unit_map[ param[:unit] ]           if param[:unit]  else 5
            requesttype[:number]                     =    param[:number]                         if  param[:number]  
            requesttype[:device]                        =    Device_map[ param[:device] ]  if param[:device]  else  0
            requesttype[:startDate]                   startDate
            requesttype[:endDate]                     endDate
            requesttypes << requesttype
          end
          return requesttypes
        end



        private
        def make_reportrequest()
          '''
          make RepoerRequestType
          '''
          params = [ params ] unless params.is_a ? Array
          requesttypes = []
          params.each do  |param|
            requesttype = {}

            requesttype[:performanceData]   =     param[:fields]        ||     %w(click impression)
            requesttype[:reportType]               =     Type_map[ param[:type] ]          if  param[:type]  else 14
            requesttype[:levelOfDetails]          =     Level_map[  param[:level] ]        if param[:level] else  11
            requesttype[:statRange]                 =     Level_map[ param[:range] ]       if param[:range] else 11
            requesttype[:unitOfTime]               =     Unit_map[ param[:unit] ]           if param[:unit]  else 5
            requesttype[:device]                        =    Device_map[ param[:device] ]  if param[:device]  else  0
            requesttype[:idOnly]                        =    param[:id_only]      ||    false
            requesttype[:startDate]                   startDate
            requesttype[:endDate]                     endDate
            requesttypes << requesttype
          end
          return requesttypes
        end

      end # Repost
    end # Baidu
  end # API
end # PPC












      # def file_id_of_query(params = {})

      #   options = {
      #     reportRequestType: {
      #       performanceData:        params[:fields] || %w(click impression),
      #       startDate:                       startDate[]    ||
      #       endDate:                        endDate[]     ||
      #       idOnly:                            params[:id_only]         || false
      #       levelOfDetails:               params[:level]             || 12
      #       format:                           params[:format]         || 2
      #       reportType:                   params[:type]               || 6
      #       statRange:                      params[:range]            || 2
      #       unitOfTime:                   params[:unit]  || 5
      #       device:                           params[:device]  || 0
      #     }
      #   }
      #   get_report_id(options)
      # end

      # def file_id_of_cost(params={})
      #   begin
      #     startDate = DateTime.parse(params[:start]).iso8601
      #     endDate = DateTime.parse(params[:end]).iso8601
      #   rescue Exception => e
      #     startDate = (Time.now - 2*24*3600).utc.iso8601
      #     endDate = (Time.now - 24*3600).utc.iso8601
      #   end
      #   options = {
      #     reportRequestType: {
      #       performanceData:        params[:fields] || %w(impression click cpc cost ctr cpm position conversion),
      #       startDate:              startDate,
      #       endDate:                endDate,
      #       levelOfDetails:         params[:level]  || 11, #::Baidu::SEM::LevelOfDetails::KEYWORDID,
      #       reportType:             params[:type]   || 14, #::Baidu::SEM::ReportType::KEYWORDID,
      #       statRange:              params[:range]  || 11, # ::Baidu::SEM::StatRange::KEYWORDID,
      #       unitOfTime:             params[:unit]   || 5 #::Baidu::SEM::UnitOfTime::DAY
      #     }
      #   }
      #   get_report_id(options)
      # end

      # def get_report_id(options={})
      #   response = request('getProfessionalReportId',options)
      #   body = response[:envelope][:body]
      #   raise "no result" if body.nil?
      #   body[:get_professional_report_id_response][:report_id]
      # end

      # def state(id)
      #   raise "empty id" if id.nil? or id.empty?
      #   request('getReportState',{reportId:id})[:envelope][:body][:get_report_state_response][:is_generated]
      # end

      # def path(id)
      #   request('getReportFileUrl',{reportId:id})[:envelope][:body][:get_report_file_url_response][:report_file_path]
      # end
