# -*- coding:utf-8 -*-
module PPC
  module API
    class Sogou
      class Report< Sogou
        Service = 'Report'
      
        # 需要用到的映射集合
        Type_map = { 'account' => 1, 'plan'=> 2, 'group'=> 3, 
                                              'keyword'=> 5, 'creative'=> 4, 'pair'=> 15, 
                                              'region'=> 3, 'wordid'=> 9 }
        Level_map = {  'account' => 1, 'plan' => 2, 'group' => 3, 
                                  'creative' => 4, 'keywordid' => 5, 'pair' => 12, 
                                  'wordid' => 6 }
        Device_map = { 'all' => 0, 'pc' => 1, 'mobile' => 2 }
        Unit_map = { 'day' => 1, 'week' => 2, 'month' => 3 }

        def self.get_id( auth, params, debug = false )
          request = make_reportrequest( params )[0]
          body =  { ReportRequestType: request }
          response = request( auth, Service, ' getReportId' ,body) 
          process( response, 'reportId', debug ){ |x| x }
        end

        def self.get_status( auth, id, debug = false)
          '''
          input id should be string
          '''
          status = {1=>'Waiting' ,2=>'Opearting' ,3=>'Finished'}
          body = { reportId:  id }
          response = request( auth, Service, ' getReportStatus' ,body)
          process( response, 'isGenerated', debug ){ |x| status[x] }
        end

        def self.get_file_url( auth, id, debug = false )
          body = { reportId:  id }
          response = request( auth, Service, ' getReportPath' ,body)
          process( response, 'reportPath', debug ){ |x| x }       
        end

        private
        def self.get_date()
         begin
            startDate = DateTime.parse(params[:start]).iso8601
            endDate = DateTime.parse(params[:end]).iso8601
          rescue Exception => e
            startDate = (Time.now - 2*24*3600).utc.iso8601
            endDate = (Time.now - 24*3600).utc.iso8601
          end
          return startDate,endDate
        end

        private 
        def self.make_realtimerequest( params )
          '''
          make RealTimeRequestType
          没有封装关键字：attribute，order,statIds
          '''
          params = [ params ] unless params.is_a? Array
          requesttypes = []
          params.each do  |param|
            requesttype = {}
            startDate, endDate = get_date()

            requesttype[:performanceData]   =     param[:fields]  && %w(cost cpc click impression ctr) || %w(click)
            requesttype[:reportType]               =     Type_map[ param[:type] ]          if  param[:type] 
            requesttype[:levelOfDetails]          =     Level_map[  param[:level] ]        if param[:level]
            requesttype[:statRange]                 =     Level_map[ param[:range] ]       if param[:range]
            requesttype[:unitOfTime]               =     Unit_map[ param[:unit] ]           if param[:unit] 
            requesttype[:device]                        =    Device_map[ param[:device] ]  if param[:device]
            requesttype[:startDate]                  =     startDate
            requesttype[:endDate]                    =     endDate
            requesttypes << requesttype
          end
          return requesttypes
        end

        private
        def self.make_reportrequest( params )
          '''
          make RepoerRequestType
          '''
          params = [ params ] unless params.is_a? Array
          requesttypes = []
          params.each do  |param|
            requesttype = {}
            startDate, endDate = get_date()

            requesttype[:performanceData]   =     param[:fields]        ||     %w(click impression)
            requesttype[:reportType]               =     Type_map[ param[:type] ]          if  param[:type]
            requesttype[:levelOfDetails]          =     Level_map[  param[:level] ]        if param[:level]
            requesttype[:statRange]                 =     Level_map[ param[:range] ]       if param[:range]
            requesttype[:unitOfTime]               =     Unit_map[ param[:unit] ]           if param[:unit]
            requesttype[:device]                        =    Device_map[ param[:device] ]  if param[:device]
            requesttype[:idOnly]                        =    param[:id_only]      ||    false
            requesttype[:startDate]                   =    startDate
            requesttype[:endDate]                     =    endDate
            requesttypes << requesttype
          end
          return requesttypes
        end

      end # Repost
    end # Baidu
  end # API
end # PPC
