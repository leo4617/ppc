# -*- coding:utf-8 -*-
module PPC
  module API
    class Baidu
      class Creative< Baidu
        Service = 'Creative'

        CreativeType = {
          id:                 :creativeId,
          group_id:           :adgroupId,
          title:              :title,
          description1:       :description1,
          description2:       :description2,
          pc_destination:     :pcDestinationUrl,
          pc_display:         :pcDisplayUrl,
          mobile_destination: :mobileDestinationUrl,
          mobile_display:     :mobileDisplayUrl,
          pause:              :pause,
          preference:         :devicePreference,
          status:             :status,
          device_preference:  :devicePreference,
        }
        @map = CreativeType

        def self.info( auth, ids )
          body = { ids: ids, idType: 7, creativeFields: CreativeType.values }
          response = request( auth, Service, 'getCreative', body )
          process(response, 'creativeType' ){|x| reverse_type( x )[0] }
        end

        def self.all( auth, group_ids )
          body = { ids: group_ids, idType: 5, creativeFields: CreativeType.values}
          response = request( auth, Service, 'getCreative', body )
          process(response, 'groupCreatives' ){|x| reverse_type( x ) }
        end

        def self.ids( auth, group_ids )
          body = { ids: group_ids, idType: 5, creativeFields: [:creativeId]}
          response = request( auth, Service, 'getCreative', body )
          process(response, 'groupCreativeIds' ){|x| reverse_type( x ) }
        end

        def self.add( auth, creatives )
          body = { creativeTypes: make_type( creatives ) }
          response = request( auth, Service, 'addCreative', body )
          process( response, 'creativeTypes' ){ |x| reverse_type(x) }
        end

        def self.get( auth, ids )
          body = { ids: ids, idType: 7, creativeFields: CreativeType.values }
          response = request( auth, Service, 'getCreative', body )
          process( response, 'creativeTypes' ){ |x| reverse_type(x) }
        end

        def self.update( auth, creatives )
          body = { creativeTypes: make_type( creatives ) }
          response = request( auth, Service, 'updateCreative', body )
          process( response, 'creativeTypes' ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids )
          body = { creativeIds: ids }
          response = request( auth, Service, 'deleteCreative', body )
          process( response, 'result' ){ |x| x }
        end

        def self.enable( auth, ids )
          creatives = ids.map{|id| {id: id, pause: false} }
          self.update( auth, creatives )
        end

        def self.pause( auth, ids )
          creatives = ids.map{|id| {id: id, pause: true} }
          self.update( auth, creatives )
        end

        def self.status( auth, ids )
          body = { ids: ids, idType: 7, creativeFields: [:creativeId, :status]}
          response = request( auth, Service, 'getCreative', body )
          process(response, 'groupCreatives' ){|x| reverse_type( x ) }
        end

      end
    end
  end
end
