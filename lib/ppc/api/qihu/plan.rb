# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Plan < Qihu
        Service = 'campaign'

        PlanType = {
          id:                 :id,
          name:               :name,
          budget:             :budget,
          region:             :region,
          search_intention:   :searchIntention,
          schedule:           :schedule,
          start_date:         :startDate,
          end_date:           :endDate,
          pause:              :status,
          add_time:           :addTime,
          update_time:        :updateTime,
          price_ratio:        :mobilePriceRate,
          extend_adtype:      :extendAdType,
          status:             :sysStatus,
          negative:           :negtiveWords,
          exact_negative:     :exactNegtiveWords,
          device:             :device,
          is_precise:         :isPrecise,
        }
        @map = PlanType

        def self.info(auth, ids)
          body = {'idList' => ids.map(&:to_s) }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'campaignList' ){ |x| reverse_type(x)[0] }
        end

        # combine two original method to provice new method
        def self.all( auth )
          self.get( auth, self.ids( auth )[:result] )
        end

         # move getCampaignId to plan module for operation call
        def self.ids( auth )
          response = request( auth, 'account', 'getCampaignIdList' )
          process( response, 'campaignIdList' ){ |x| x.map(&:to_i) }
        end 

        def self.get(auth, ids)
          body = {'idList' => ids.map(&:to_s) }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'campaignList' ){ |x| reverse_type(x) }
        end

        # 奇虎计划API不提供批量服务
        def self.add( auth, plan )
          response = request( auth, Service, 'add', make_type( plan )[0])
          process( response, 'id' ){ |x| [ { id:x.to_i, name: plan[0][:name]} ] }
        end

        def self.update( auth, plan ) 
          response = request( auth, Service, 'update', make_type( plan )[0])
          process( response, 'id' ){ |x| [ { id:x.to_i } ] }
        end

        def self.delete( auth, id )
          response = request( auth, Service, 'deleteById', { id: id[0] } )
          process( response, 'affectedRecords' ){ |x|  x == '1'? 'success' : 'fail' }
        end

        def self.enable( auth, id )
          self.update(auth, {id: id[0], status: "enable"})
        end

        def self.pause( auth, id )
          self.update(auth, {id: id[0], status: "pause"})
        end

      end
    end
  end
end
