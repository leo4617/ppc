# -*- coding:utf-8  -*-
module PPC
  module API
    class Sm
      class Group < Sm
        Service = 'adgroup'

        GroupType = {}
          plan_id:        :campaignId,
          id:             :adgroupId,
          name:           :adgroupName,
          price:          :maxPrice,
          negative:       :negativeWords,
          exact_negative: :exactNegativeWords,
          pause:          :pause,
          status:         :status,
          os:             :adPlatformOS,
        }
        @map = GroupType

        def self.ids( auth )
          response = request(auth, Service, "getAllAdgroupId")
          process(response, 'campaignAdgroupIds'){|x| make_planGroupIds(x)}
        end

        def self.get(auth, ids)
          ids = [ ids ] unless ids.is_a? Array
          body = {adgroupIds: ids}
          response = request(auth, Service, "getAdgroupByAdgroupId", body)
          process(response, 'adgroupTypes'){|x| reverse_type(x)}
        end

        def self.add(auth, groups)
          adgroup_types = make_type(groups)
          body = {adgroupTypes: adgroup_types}
          response = request(auth, Service, "addAdgroup", body)
          process(response, 'adgroupTypes'){|x| reverse_type(x)}
        end

        def self.update(auth, groups)
          adgroup_types = make_type(groups)
          body = {adgroupTypes: adgroup_types}
          response = request(auth, Service, "updateAdgroup", body)
          process(response, 'adgroupTypes'){|x| reverse_type(x)}
        end

        def self.delete(auth, ids)
          ids = [ids] unless ids.is_a? Array
          body = {adgroupIds: ids}
          response = request(auth, Service, "deleteAdgroup", body, "delete")
          process(response, 'result'){ |x|  x  }
        end

        def self.search_by_plan_id(auth, ids)
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          response = request(auth, Service, "getAdgroupByCampaignId", body)
          process(response, 'campaignAdgroups' ){ |x| make_planGroups( x ) }
        end

        def self.search_id_by_plan_id( auth, ids )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          response = request(auth, Service, "getAdgroupIdByCampaignId", body)
          process(response, 'campaignAdgroupIds'){ |x| make_planGroupIds( x ) }
        end

        private
        def self.make_planGroupIds( campaignAdgroupIds )
          planGroupIds = []
          campaignAdgroupIds.each do |campaignAdgroupId|
            planGroupId = { }
            planGroupId[:plan_id] = campaignAdgroupId['campaignId']
            planGroupId[:group_ids] = campaignAdgroupId['adgroupIds']
            planGroupIds << planGroupId
          end
          return planGroupIds
        end

        private
        def self.make_planGroups( campaignAdgroups )
          planGroups = []
          campaignAdgroups.each do |campaignAdgroup|
            planGroup = {}
            planGroup[:plan_id] = campaignAdgroup['campaignId']
            planGroup[:groups] = reverse_type( campaignAdgroup['adgroupTypes'] )
            planGroups << planGroup
          end
          return planGroups
        end

      end # class group
    end # class baidu
  end # API
end # module
