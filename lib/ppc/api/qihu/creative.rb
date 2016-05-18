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
          body  = { 'idList' => ids.map(&:to_s) }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'creativeList'){ |x| reverse_type(x)[0] }
        end

        # combine two methods to provide another mether
        def self.all( auth, id )
          creative_ids = self.ids( auth, id )[:result][0][:creative_ids]
          response = self.get( auth , creative_ids )
          response[:result] = [ { group_id: id, creatives: response[:result ] } ] if response[:succ]
          response
        end

        def self.ids( auth, id )
          response = request( auth, Service, 'getIdListByGroupId', {"groupId" => id[0]} )
          process( response, 'creativeIdList' ){ |x| { group_id: id, creative_ids: x.map(&:to_i) } }
        end

        def self.get( auth, ids )
          body  = { 'idList' => ids.map(&:to_s) }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'creativeList'){ |x| reverse_type(x) }
        end

        def self.add( auth,  creatives )
          body = { 'creatives' => make_type( creatives ).to_json}
          response = request( auth, Service, 'add', body )
          process( response, 'creativeIdList'){ |x| x.map{|tmp| { id: i.to_i } } }
        end

        def self.update( auth, creatives )
          body = { 'creatives' => make_type( creatives ).to_json}
          response = request( auth, Service, 'update', body )
          process( response, 'affectedRecords', 'failCreativeIds' ){ |x| x }
        end

        def self.delete( auth, ids )
          body = { 'idList' => ids.map(&:to_s) }
          response = request( auth, Service, 'deleteByIdList', body )
          process( response, 'affectedRecords' ){ |x|x }
        end

        def self.enable( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, status: "enable"} } )
        end

        def self.pause( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, status: "pause"} } )
        end

        def self.status( auth, ids )
          body = { idList: ids.map(&:to_s) }
          response = request( auth, Service, 'getStatusByIdList', body )
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
