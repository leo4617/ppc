# -*- coding:utf-8 -*-
module PPC
  module API
    class Sm
      class Creative< Sm
        Service = 'creative'

        @map =[
                [:id, :creativeId],
                [:group_id, :adgroupId],
                [:title, :title],
                [:description1, :description1],
                [:pause, :pause],
                [:mobile_destination, :destinationUrl],
                [:mobile_display, :displayUrl],
                [:status, :status]
              ]     

        def self.add(auth, creatives)
          body = {creativeTypes: make_type(creatives)}
          response = request(auth, Service, 'addCreative', body)
          process(response, 'creativeTypes'){|x| reverse_type(x)}
        end

        def self.get(auth, ids)
          ids = [ids] unless ids.is_a? Array
          body = {creativeIds: ids}
          response = request(auth, Service, 'getCreativeByCreativeId', body)
          process(response, 'creativeTypes'){|x| reverse_type(x)}
        end

        def self.update(auth, creatives)
          body = {creativeTypes: make_type(creatives)}
          response = request(auth, Service, 'updateCreative', body)
          process(response, 'creativeTypes'){|x| reverse_type(x)}
        end

        def self.delete(auth, ids)
          ids = [ids] unless ids.is_a? Array
          body = {creativeIds: ids}
          response = request(auth, Service, 'deleteCreative', body, 'delete')
          process(response, 'result'){|x| x}
        end

        def self.search_id_by_group_id(auth, ids)
          ids = [ids] unless ids.is_a? Array
          body = {adgroupIds: ids}
          response = request(auth, Service, 'getCreativeIdByAdgroupId', body)
          process(response, 'groupCreativeIds'){|x| make_groupCreativeIds(x)}
        end

        def self.search_by_group_id(auth, ids)
          ids = [ids] unless ids.is_a? Array
          body = {adgroupIds: ids}
          response = request(auth, Service, 'getCreativeByAdgroupId', body)
          process(response, 'groupCreatives'){|x| make_groupCreatives(x)}
        end

        private
        def self.make_groupCreativeIds( groupCreativeIds )
          group_creative_ids = []
          groupCreativeIds.each do |groupCreativeId|
            group_creative_id = { }
            group_creative_id[:group_id] = groupCreativeId['adgroupId']
            group_creative_id[:creative_ids] = groupCreativeId['creativeIds']
            group_creative_ids << group_creative_id
          end
          return group_creative_ids
        end

        private
        def self.make_groupCreatives( groupCreatives )
          group_creatives = []
          groupCreatives.each do |groupCreative |
            group_creative = {}
            group_creative[:group_id] = groupCreative['adgroupId']
            group_creative[:creatives] = reverse_type( groupCreative['creativeTypes'] )
            group_creatives << group_creative
          end
          return group_creatives
        end

      end
    end
  end
end
