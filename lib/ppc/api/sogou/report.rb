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
          request = make_reportrequest( params )
          body =  { ReportRequestType: request }
          response = request( auth, Service, ' getReportId' ,body) 
          process( response, 'reportId', debug ){ |x| x }
        end

        def self.get_state( auth, id, debug = false)
          '''
          input id should be string
          '''
          status = {1=>'Waiting' ,2=>'Opearting' ,3=>'Finished'}
          body = { reportId:  id }
          response = request( auth, Service, ' getReportStatus' ,body)
          process( response, 'isGenerated', debug ){ |x| status[x] }
        end

        def self.get_url( auth, id, debug = false )
          body = { reportId:  id }
          response = request( auth, Service, ' getReportPath' ,body)
          process( response, 'reportPath', debug ){ |x| x }       
        end

        private
        def self.get_date( param )
         begin
            startDate = DateTime.parse(param[:start]).iso8601
            endDate = DateTime.parse(param[:end]).iso8601
          rescue Exception => e
            startDate = (Time.now - 2*24*3600).utc.iso8601
            endDate = (Time.now - 24*3600).utc.iso8601
          end
          return startDate,endDate
        end

        private
        def self.make_reportrequest( param )
          '''
          make RepoerRequestType
          ======================
          For more docs please have a look at
          ::PPC::API::Baidu::Report:make_reportrequest()
          '''
          requesttype = {}
          startDate, endDate = get_date( param )
          requesttype[:performanceData]    =     param[:fields]  && %w(cost cpc click impression ctr) || %w(click)
          requesttype[:reportType]         =     Type_map[ param[:type] ]        if  param[:type] 
          requesttype[:levelOfDetails]     =     Level_map[  param[:level] ]     if param[:level]
          requesttype[:statRange]          =     Level_map[ param[:range] ]      if param[:range]
          requesttype[:unitOfTime]         =     Unit_map[ param[:unit] ]        if param[:unit] 
          requesttype[:platform]           =     Device_map[ param[:device] ]    if param[:device]
          requesttype[:idOnly]             =     param[:id_only]                 if param[:id_only]!=nil
          requesttype[:startDate] = param[:startDate]==nil ? startDate :param[:startDate]
          requesttype[:endDate]   = param[:endDate]==nil   ? endDate :param[:endDate]
          return requesttype
        end

      end # Repost
    end # Baidu
  end # API
end # PPC
