# -*- coding:utf-8 -*-
module PPC
  module API
    class Sm
      class Creative< Sm
        Service = 'creative'

        CreativeType = {
          id:                 :creativeId,
          group_id:           :adgroupId,
          title:              :title,
          description1:       :description1,
          pause:              :pause,
          mobile_destination: :destinationUrl,
          mobile_display:     :displayUrl,
          status:             :status,
          creative_ids:       :creativeIds,
          creatives:          :creativeTypes,
        }
        @map = CreativeType

        def self.info(auth, ids)
          response = request(auth, Service, 'getCreativeByCreativeId', {creativeIds: ids})
          process(response, 'creativeTypes'){|x| reverse_type(x)}
        end

        def self.all(auth, ids)
          response = request(auth, Service, 'getCreativeByAdgroupId', {adgroupIds: ids})
          process(response, 'groupCreatives'){|x| x.map{|y| y["creativeTypes"].map{|z| reverse_type(z)}}.flatten }
        end

        def self.ids(auth, ids)
          response = request(auth, Service, 'getCreativeIdByAdgroupId', {adgroupIds: ids})
          process(response, 'groupCreativeIds'){|x| reverse_type(x)}
        end

        def self.add(auth, creatives)
          body = {creativeTypes: make_type(creatives)}
          response = request(auth, Service, 'addCreative', body)
          process(response, 'creativeTypes'){|x| reverse_type(x)}
        end

        def self.get(auth, ids)
          response = request(auth, Service, 'getCreativeByCreativeId', {creativeIds: ids})
          process(response, 'creativeTypes'){|x| reverse_type(x)}
        end

        def self.update(auth, creatives)
          body = {creativeTypes: make_type(creatives)}
          response = request(auth, Service, 'updateCreative', body)
          process(response, 'creativeTypes'){|x| reverse_type(x)}
        end

        def self.delete(auth, ids)
          response = request(auth, Service, 'deleteCreative', {creativeIds: ids}, 'delete')
          process(response, 'result'){|x| x}
        end

        def self.enable( auth, ids )
          creatives = ids.map{|id| {id: id, pause: false} }
          self.update( auth, creatives )
        end

        def self.pause( auth, ids )
          creatives = ids.map{|id| {id: id, pause: true} }
          self.update( auth, creatives )
        end

      end
    end
  end
end
