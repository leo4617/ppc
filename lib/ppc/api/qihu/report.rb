# -*- coding:utf-8 -*-
require 'json'

module PPC
  module API
    class Qihu
      class Report< Qihu
        Service = 'report'
        def self.get_keyword_report( auth, params )
          body = make_report_request_type( params )
          p body
          response = request( auth, Service, 'queryword', body )
          p response
        end

        private 
        def self.make_report_request_type( param )
          type = {}
          # add option
          type[:level] = param[:level]
          type[:page] = param[:page]
          # add ids
          if param[:ids] != nil
            ids = [ param[:ids] ] unless param[:ids].is_a? Array
            type[:idList] = ids.to_json
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
            startDate = (Time.now - 2*24*3600).utc.iso8601
            endDate = (Time.now - 24*3600).utc.iso8601
          return startDate,endDate
        end

      end
    end
  end
end