# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Creative< Qihu
        Service = 'creative'

        CreativeType = {
          id:                 :id,
          plan_id:            :campaignId,
          group_id:           :groupId,
          title:              :title,
          description1:       :description1,
          description2:       :description2,
          description3:       :descSecondLine,
          pc_destination:     :destinationUrl,
          pc_display:         :displayUrl,
          mobile_destination: :mobileDestinationUrl,
          mobile_display:     :mobileDisplayUrl,
          pause:              :status,
          mobile_pause:       :mobileStatus,
          add_time:           :addTime,
          updateTime:         :updateTime,
        }
        @map = CreativeType

        @status_map = {
          id:       :id,
          quality:  :qualityScore,
          pause:    :status,
        }

        def self.info( auth, ids )
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'creativeList'){ |x| reverse_type(x)[0] }
        end

        # combine two methods to provide another mether
        def self.all( auth, group_id )
          results = self.ids( auth, group_id )
          return results unless results[:succ]
          self.get( auth , results[:result] )
        end

        def self.ids( auth, group_id )
          response = request( auth, Service, 'getIdListByGroupId', {"groupId" => group_id[0]} )
          process( response, 'creativeIdList' ){ |x| x.map(&:to_i) }
        end

        def self.get( auth, ids )
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'creativeList'){ |x| reverse_type(x) }
        end

        def self.add( auth,  creatives )
          response = request( auth, Service, 'add', { creatives: make_type( creatives ) } )
          process( response, 'creativeIdList'){ |x| x.map{|tmp| { id: i.to_i } } }
        end

        def self.update( auth, creatives )
          response = request( auth, Service, 'update', { creatives: make_type( creatives ) } )
          process( response, 'affectedRecords', 'failCreativeIds' ){ |x| x }
        end

        def self.delete( auth, ids )
          response = request( auth, Service, 'deleteByIdList', { idList: ids } )
          process( response, 'affectedRecords' ){ |x|x }
        end

        def self.enable( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, pause: "enable"} } )
        end

        def self.pause( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, pause: "pause"} } )
        end

        def self.status( auth, ids )
          response = request( auth, Service, 'getStatusByIdList', { idList: ids } )
          process( response, 'creativeList' ){ |x| reverse_type( x, @status_map ) }
        end

        # quality 本质上和 status 在一个方法里面
        def self.quality( auth, ids )
          self.status( auth, ids)
        end

      end
    end
  end
end
