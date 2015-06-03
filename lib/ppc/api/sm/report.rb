# -*- coding:utf-8 -*-
module PPC
  module API
    class Sm
      class Report< Sm
        Service = 'Report'

        # 需要用到的映射集合
        Type_map = { 'account' => 2, 'plan'=> 10, 'group'=> 11,
                      'keyword'=> 14, 'creative'=> 12,
                       'region'=> 3, 'query'=>6, 'trail' => 21, "tel" => 22,
                       "app" => 23, "none" => 24}

        Level_map = {  'account' => 2, 'plan' => 3, 'group' => 5,
                        'creative'=> 7, 'keywordid' => 11, 'trail' => 21, "tel" => 22,
                         "app" => 23, 'query_creative' => 12}

        Device_map = { 'all' => 0, 'pc' => 1, 'mobile' => 2 }

        Unit_map = { 'day' => 5, 'month' => 3, 'range' => 8 }

        ########################
        # API wraping function #
        ########################
        def self.get_id( auth, params  )
          body = make_reportrequest( params )
          response = request( auth, 'report' , 'getReport' ,body)
          process( response, 'taskId' ){ |x| x }
        end

        def self.get_state( auth, id )
          '''
          input id should be string
          '''
          body = { taskId:  id }
          response = request( auth, 'task' , 'getTaskState' ,body)
          process( response, 'status' ){ |x| x }
        end

        def self.get_fileId( auth,  id  )
          body = { taskId:  id }
          response = request( auth, 'task' , 'getTaskState' ,body)
          process( response, 'fileId' ){ |x| x }
        end

        def self.get_file( auth,  id  )
          body = { fileId:  id }
          response = request( auth, 'file' , 'download' ,body)
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
          requesttype[:performanceData]   =     param[:fields]  || %w(click impression cost cpc ctr)
          requesttype[:reportType]        =     Type_map[ param[:type] ]      if param[:type]
          requesttype[:levelOfDetails]    =     Level_map[ param[:level] ]    if param[:level]
          requesttype[:statRange]         =     Level_map[ param[:range] ]    if param[:range]
          requesttype[:unitOfTime]        =     Unit_map[ param[:unit] ]      if param[:unit]
          requesttype[:device]            =     Device_map[ param[:device] ]  if param[:device]
          requesttype[:idOnly]            =     param[:id_only] || false
          requesttype[:startDate]         =     parse_date( param[:startDate] )
          requesttype[:endDate]           =     parse_date( param[:endDate] )
          requesttype[:statIds]           =     param[:statIds] if param[:type] == "keyword" && param[:range] != "account"
          return requesttype
        end

        private
        def self.parse_date( date )
          """
          Cast string to time:
          'YYYYMMDD' => Time
          """
          if date
            date = Date.parse(date)
          else
            date = Date.today
          end
        end

        #################################
        # useful function for operation #
        #################################
        def self.query_report( auth, param = {}, debug = false )
          param[:type]   ||= 'query'
          param[:fields] ||=  %w(click impression)
          param[:range]  ||= 'account'
          param[:unit]   ||= 'day'
          download_report( auth, param, debug )
        end

        def self.creative_report( auth, param = {}, debug = false )
          param[:type]   ||= 'creative'
          param[:fields] ||=  %w(click impression)
          param[:range]  ||= 'account'
          param[:unit]   ||= 'day'
          download_report( auth, param, debug )
        end

        def self.keyword_report( auth, param = {}, debug = false )
          param[:type]   ||= 'keyword'
          param[:fields] ||=  %w(click impression cost cpc ctr)
          param[:range]  ||= 'account'
          param[:unit]   ||= 'day'
          download_report( auth, param, debug )
        end

        def self.download_report( auth, param, debug = false )
          response = get_id( auth, param )
          if response[:succ]
            id = response[:result]
            p "Got report id:" + id.to_s if debug
            loop do
              sleep 2
              break if get_state( auth, id )[:result] == 'FINISHED'
              p "Report is not generated, waiting..." if debug
            end
            fileId = get_fileId(auth, id)[:result]
            return get_file(auth, fileId).force_encoding("utf-8")
          else
            raise response[:failure][0]["message"]
          end
        end

      end # Repost
    end # Sm
  end # API
end # PPC
