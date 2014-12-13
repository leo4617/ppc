# -*- coding:utf-8 -*-
require 'json'

module PPC
  module API
    class Qihu
      class Report< Qihu
        Service = 'report'

        @map =[
                [:queryword,:queryword],
                [:plan_id,:campaignId],
                [:creative_id,:creativeId],
                [:keyword,:keyword],
                [:views,:views],
                [:clicks,:clicks],
                [:startDate,:startDate],
                [:endDate,:endDate],
                [:date,:date],
                [:keyword_id,:keywordId],
                [:group_id,:groupId],
                [:cost,:totalCost],
                [:position,:avgPosition],
                [:total_num,:totalNumber],
                [:total_page,:totalPage]
              ]

        ###################
        # API abstraction #
        ###################
        def self.abstract( auth, type_name, method_name, key, param = nil )
          body = make_type( param )
          response = request( auth, Service, method_name, body )
          process( response, key ){ |x| get_item( x )}
        end

        type_list = ['keyword', 'query', 'creative', 'sublink']
        type_list.each do |type|
          # type
          define_singleton_method type.to_sym do |auth, param|
              abstract( auth, type, type, type+'List', param )
          end
          # typeCount
          define_singleton_method (type+'_count').to_sym do |auth, param|
              abstract( auth, type, type+'Count', '', param )
          end
          # typeNow
          define_singleton_method (type+'_now').to_sym do |auth, param|
              abstract( auth, type, type+'Now', type+'List', param )
          end
          # typeNowCount
          define_singleton_method (type+'_now_count').to_sym do |auth, param|
              abstract( auth, type, type+'NowCount', '', param )
          end
        end


        ############################
        # define operation methods #
        ############################
        def self.download_report(auth, type, param)
          # deal_with time
          param[:startDate] = parse_date( param[:startDate] )
          param[:endDate] = parse_date( param[:endDate] )
          now = Time.now.to_s[0...10]
          is_now = now==param[:startDate]
        
          # get page num
          if is_now
            method = (type+'_now_count').to_sym
            total_page = send(method, auth, param)
          else
            num_of_page = (type+'_count').to_sym
            num_of_page = send(method, auth, param)
          end

          # combine pages and get whole report
          report = []
          # page_num.times do each | page_i|
          #   if is_now
          #     report_i = eval
          #   else
          #     report_i = eval
          #   end
          #   report.append( report_i )
          # end
          return report
        end

        # incase idlist == nil
        private
        def self.get_item( params )
          return nil if params == nil
          return reverse_type( params ) 
        end

        private 
        def self.make_type( param )
          type = {}
          # add option
          type[:level] = param[:level] || 'account'
          type[:page] = param[:page] || 1
          # add ids
          if param[:ids] != nil
            ids = param[:ids] 
            ids = [ ids ] unless ids.is_a? Array
            type[:IdList] = ids.to_json
          end
          # add date
          if param[:startDate]==nil || param[:endDate]==nil
            type[:startDate], type[:endDate] = get_date()
          else
            type[:startDate] = param[:startDate]
            type[:endDate] = param[:endDate]
          end

          return type
        end

        private
        def self.get_date()
            endDate = Time.now.to_s[0,10]
            startDate = (Time.now - 24*3600).to_s[0,10]
          return startDate,endDate
        end

        private 
        def self.parse_date( date )
          """
          Cast string to time:
          'YYYYMMDD' => Time
          """
          if date
            y = date[0..3]
            m = date[4..5]
            d = date[6..7]
            date = Time.new( y, m, d )
          else
            date = (Time.now - 24*3600)
          end
          date.to_s[0,10]
        end

      end # Report
    end # Qihu
  end # API
end # PPC
