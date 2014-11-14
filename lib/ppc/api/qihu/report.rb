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
                [:date,:date],
                [:keyword_id,:keywordId],
                [:group_id,:groupId],
                [:cost,:totalCost],
                [:position,:avgPosition]
              ]

        def self.cost_report( auth, params )
          body = make_type( params )
          response = request( auth, Service, 'keyword', body )
          process( response, 'keywordList' ){ |x| get_item( x )}
        end

        def self.query_report( auth, params )
          body = make_type( params )
          response = request( auth, Service, 'queryword', body )
          process( response, 'querywordList' ){ |x| get_item( x )}
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
          type[:level] = param[:level]
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

      end
    end
  end
end