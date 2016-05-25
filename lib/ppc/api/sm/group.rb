# -*- coding:utf-8  -*-
module PPC
  module API
    class Sm
      class Group < Sm
        Service = 'adgroup'

        GroupType = {
          plan_id:        :campaignId,
          id:             :adgroupId,
          name:           :adgroupName,
          price:          :maxPrice,
          negative:       :negativeWords,
          exact_negative: :exactNegativeWords,
          pause:          :pause,
          status:         :status,
          os:             :adPlatformOS,
          group_ids:      :adgroupIds,
          groups:         :adgroupTypes,
        }
        @map = GroupType

        def self.info(auth, ids)
          response = request(auth, Service, "getAdgroupByAdgroupId", {adgroupIds: ids} )
          process(response, 'adgroupTypes'){|x| reverse_type(x)[0] }
        end

        def self.all( auth, plan_ids )
          response = request(auth, Service, "getAdgroupByCampaignId", {campaignIds: plan_ids} )
          process(response, 'campaignAdgroups' ){ |x| reverse_type(x.map{|temp| temp["adgroupTypes"]}.flatten) }
        end

        def self.ids( auth, plan_ids )
          response = request(auth, Service, "getAdgroupIdByCampaignId", {campaignIds: plan_ids} )
          process(response, 'campaignAdgroupIds'){ |x| reverse_type( x ) }
        end

        def self.get(auth, ids)
          response = request(auth, Service, "getAdgroupByAdgroupId", {adgroupIds: ids} )
          process(response, 'adgroupTypes'){|x| reverse_type(x) }
        end

        def self.add(auth, groups)
          body = {adgroupTypes: make_type(groups)}
          response = request(auth, Service, "addAdgroup", body)
          process(response, 'adgroupTypes'){|x| reverse_type(x) }
        end

        def self.update(auth, groups)
          body = {adgroupTypes: make_type(groups)}
          response = request(auth, Service, "updateAdgroup", body)
          process(response, 'adgroupTypes'){|x| reverse_type(x) }
        end

        def self.delete(auth, ids)
          response = request(auth, Service, "deleteAdgroup", {adgroupIds: ids} , "delete")
          process(response, 'result'){ |x|  x  }
        end

        def self.enable( auth, ids )
          groups = ids.map{|id| {id: id, pause: false} }
          self.update( auth, groups )
        end

        def self.pause( auth, ids )
          groups = ids.map{|id| {id: id, pause: true} }
          self.update( auth, groups )
        end

      end # class group
    end # class baidu
  end # API
end # module
