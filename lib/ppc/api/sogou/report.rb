# -*- coding:utf-8 -*-
module PPC
  module API
    class Sogou
      class Report< Sogou
        Service = 'Report'
      
        # 需要用到的映射集合
        Type_map = { 'account' => 1, 'plan'=> 2, 'group'=> 3, 
                      'keyword'=> 5, 'creative'=> 4, 'pair'=> 15, 
                       'query'=> 3 }

        Range_map = {  'account' => 1, 'plan' => 2, 'group' => 3, 
                        'creative' => 4, 'keyword' => 5 }

        Device_map = { 'all' => 0, 'pc' => 1, 'mobile' => 2 }

        Unit_map = { 'day' => 1, 'week' => 2, 'month' => 3 }

        def self.get_id( auth, params )
          request = make_reportrequest( params )
          body =  { reportRequestType: request }
          response = request( auth, Service, 'getReportId' ,body) 
          process( response, 'reportId' ){ |x| x }
        end

        def self.get_state( auth, id )
          '''
          input id should be string
          '''
          status = {'-1'=>'Waiting' ,'0'=>'Opearting' ,'1'=>'Finished'}
          body = { reportId:  id }
          response = request( auth, Service, 'getReportState' ,body)
          process( response, 'isGenerated' ){ |x| status[x] }
        end

        def self.get_url( auth, id )
          body = { reportId:  id }
          response = request( auth, Service, 'getReportPath' ,body)
          process( response, 'reportFilePath' ){ |x| x }       
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
          requesttype[:performanceData]    =     param[:fields] || %w(click)
          requesttype[:reportType]         =     Type_map[ param[:type] ]        if  param[:type] 
          requesttype[:statRange]          =     Range_map[ param[:range] ]      if param[:range]
          requesttype[:unitOfTime]         =     Unit_map[ param[:unit] ]        if param[:unit] 
          requesttype[:platform]           =     Device_map[ param[:device] ]    if param[:device]
          requesttype[:idOnly]             =     param[:id_only]                 if param[:id_only]!=nil
          requesttype[:startDate]          =     (Time.parse( param[:startDate] ) rescue Time.now - 86400).utc.iso8601
          requesttype[:endDate]            =     (Time.parse( param[:endDate] ) rescue Time.now - 86400).utc.iso8601
          requesttype[:statIds]            =     param[:statIds]                 if param[:statIds]
          return requesttype
        end

        ###########################
        # intreface for Operation #
        ###########################
        def self.download_report( auth, param )
          response = get_id( auth, param )
          if response[:succ]
            id = response[:result]
            p "Got report id:" + id.to_s if ENV["DEBUG"] 
            times = 0
            loop do
              raise "The speed of get_status is too slow." if (times += 1) > 10
              break if get_state( auth, id )[:result] == 'Finished'
              p "Report is not generated, waiting..." if ENV["DEBUG"] 
              sleep 5
            end

            url = get_url( auth, id )[:result]
            ActiveSupport::Gzip.decompress( open(url).read ).force_encoding('gb18030').encode('utf-8')
          else
            raise response[:failure][:message]
          end
        end

        def self.query_report( auth, param = {} )
          param[:type]   ||= 'query'
          param[:fields] ||=  %w(click)
          param[:range]  ||= 'account'
          param[:unit]   ||= 'day'
          download_report( auth, param )
        end

        def self.creative_report( auth, param = {} )
          param[:type]   ||= 'creative'
          param[:fields] ||=  %w( cost cpc click impression ctr )
          param[:range]  ||= 'account'
          download_report( auth, param )
        end

        def self.keyword_report( auth, param = {} )
          param[:type]   ||= 'keyword'
          param[:fields] ||=  %w( cost cpc click impression ctr )
          param[:range]  ||= 'account'
          download_report( auth, param )
        end

        def self.account_report( auth, param = {} )
          param[:type]   ||= 'account'
          param[:fields] ||=  %w( cost cpc click impression ctr )
          param[:range]  ||= 'account'
          download_report( auth, param )
        end

        def self.plan_report( auth, param = {} )
          param[:type]   ||= 'plan'
          param[:fields] ||=  %w( cost cpc click impression ctr )
          param[:range]  ||= 'plan'
          download_report( auth, param )
        end

        def self.group_report( auth, param = {} )
          param[:type]   ||= 'group'
          param[:fields] ||=  %w( cost cpc click impression ctr)
          param[:range]  ||= 'group'
          download_report( auth, param )
        end

      end # Repost
    end # Baidu
  end # API
end # PPC
