# -*- coding:utf-8 -*-
require 'json'

module PPC
  module API
    class Qihu
      class Report< Qihu
        Service = 'report'

        ReportType = {
          queryword:    :queryword,
          plan_id:      :campaignId,
          creative_id:  :creativeId,
          keyword:      :keyword,
          views:        :views,
          clicks:       :clicks,
          startDate:    :startDate,
          endDate:      :endDate,
          date:         :date,
          keyword_id:   :keywordId,
          group_id:     :groupId,
          cost:         :totalCost,
          position:     :avgPosition,
          total_num:    :totalNumber,
          total_page:   :totalPage,
        }
        @map = ReportType

        ###################
        # API abstraction #
        ###################
        def self.abstract( auth, type_name, method_name, key, param = nil, &func )
          response = request( auth, Service, method_name, make_type( param ) )
          process( response, key ){ |x| func[ x ] }
        end

        %w(keyword query creative sublink).each do |type|
          # type
          define_singleton_method type.to_sym do |auth, param|
              abstract( auth, type, type, type+'List', param ){ |x| x}
          end
          # typeCount
          define_singleton_method (type+'_count').to_sym do |auth, param|
              abstract( auth, type, type+'Count', '', param ){ |x| reverse_type( x )[0] }
          end
          # typeNow
          define_singleton_method (type+'_now').to_sym do |auth, param|
              abstract( auth, type, type+'Now', type+'List', param ){ |x| x['item']}
          end
          # typeNowCount
          define_singleton_method (type+'_now_count').to_sym do |auth, param|
              abstract( auth, type, type+'NowCount', '', param ){ |x| reverse_type( x )[0] }
          end
        end

        ############################
        # Interfaces for operation #
        ############################
        def self.keyword_report( auth, param, debug = false )
          download_report(auth, 'keyword', param, debug )
        end

        def self.creative_report( auth, param, debug = false )
          download_report(auth, 'creative', param, debug)
        end
        
        def self.download_report(auth, type, param, debug = false)
          # deal_with time
          is_now = Date.today == Date.parse(param[:startDate])
        
          # get page num
          method    = (type+ (is_now ? '_now' : '') + '_count').to_sym
          response  = send(method, auth, param)
          count     = response[:result]
          method    = (type+ (is_now ? '_now' : '')).to_sym
          
          if count && count[:total_page]
            count[:total_page].to_i.times.map do | page_i|
              p "Start downloading #{page_i+1}th page, totally #{count[:total_page]} pages"
              param[:page] = page_i +1
              send(method, auth, param)[:result]
            end
          else
            response
          end
        end

        ###################
        # Helper Function #
        ###################
        # incase idlist == nil

        private 
        def self.make_type( param )
          param[:level]   ||= 'account'
          param[:page]    ||= 1
          param[:IdList]    = [param.delete(:ids)].flatten.map(&:to_s)
          param[:startDate] = Date.parse(param[:startDate]).to_s rescue Date.today.to_s
          param[:endDate]   = Date.parse(param[:endDate]).to_s   rescue Date.today.to_s
          param
        end

      end # Report
    end # Qihu
  end # API
end # PPC
