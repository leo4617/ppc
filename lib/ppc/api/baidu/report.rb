# -*- coding:utf-8 -*-
module PPC
  module API
    class Baidu
      class Report< Baidu
        Service = 'Report'
      
        # 需要用到的映射集合
        Type_map = { 'account' => 2, 'plan'=> 10, 'group'=> 11, 
                      'keyword'=> 14, 'creative'=> 12, 'pair'=> 15, 
                       'region'=> 3, 'wordid'=> 9 , 'query'=>6 }

        Level_map = {  'account' => 2, 'plan' => 3, 'group' => 5, 
                        'creative'=> 7, 'keywordid' => 11, 'pair' => 12, 
                         'wordid' => 6 }

        Device_map = { 'all' => 0, 'pc' => 1, 'mobile' => 2 }

        Unit_map = { 'day' => 5, 'week' => 4, 'month' => 3, 'year' => 1, 'hour' => 7 }

        def self.get_id( auth, params  )
          request = make_reportrequest( params )
          body =  { reportRequestType:  request }
          response = request( auth, Service, 'getProfessionalReportId' ,body) 
          process( response, 'reportId' ){ |x| x }
        end

        def self.get_state( auth, id )
          '''
          input id should be string
          '''
          status = {1=>'Waiting' ,2=>'Opearting' ,3=>'Finished'}
          body = { reportId:  id }
          response = request( auth, Service, 'getReportState' ,body)
          process( response, 'isGenerated' ){ |x| status[x] }
        end

        def self.get_url( auth, id  )
          body = { reportId:  id }
          response = request( auth, Service, 'getReportFileUrl' ,body)
          process( response, 'reportFilePath' ){ |x| x }       
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
          startDate = param[:startDate] || startDate
          endDate = param[:endDate] || endDate
          return startDate,endDate
        end

        private
        def self.make_reportrequest( param )
          """
          make RepoerRequestType
          ==============
          @Input : :fields,:type,:level,:range,:unit,:device,:id_only,:startDate:endDate
          ==============
          Note:
            We cast [ type, level, range, unit,device ] from int to string.
          For more information please see those map at the begining of the file
          """
          requesttype = {}
          startDate, endDate = get_date( param )
          requesttype[:performanceData]   =     param[:fields]  || %w(click impression)
          requesttype[:reportType]        =     Type_map[ param[:type] ]      if  param[:type]
          requesttype[:levelOfDetails]    =     Level_map[  param[:level] ]   if param[:level]
          requesttype[:statRange]         =     Level_map[ param[:range] ]    if param[:range]
          requesttype[:unitOfTime]        =     Unit_map[ param[:unit] ]      if param[:unit]
          requesttype[:device]            =     Device_map[ param[:device] ]  if param[:device]
          requesttype[:idOnly]            =     param[:id_only] || false
          requesttype[:startDate]         =     startDate
          requesttype[:endDate]           =     endDate
          return requesttype
        end

      end # Repost
    end # Baidu
  end # API
end # PPC
