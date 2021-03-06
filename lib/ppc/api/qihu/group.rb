# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Group < Qihu
        Service = 'group'

        GroupType = {
          id:             :id,
          plan_id:        :campaignId,
          pause:          :status,
          name:           :name,
          price:          :price,
          # negateive为json格式，make_type要定制
          negative:       :negativeWords,
          exact_negative: :exactNegativeWords,
          add_time:       :addTime,
          update_time:    :updateTime,
          from_time:      :fromTime,
        }
        @map = GroupType

        def self.info( auth, ids )
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'groupList' ){ |x| reverse_type(x)[0] }
        end

        def self.all( auth, plan_id )
          group_ids = self.ids( auth, plan_id )[:result][:group_ids]
          self.get( auth, group_ids )
        end

        def self.ids( auth, plan_id )
          response = request( auth, Service, 'getIdListByCampaignId', { campaignId: plan_id[0] } )
          process( response, 'groupIdList' ){ |x| { plan_id: plan_id[0], group_ids: x.map(&:to_i) } }
        end

        def self.get( auth, ids )
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'groupList' ){ |x| reverse_type(x) }
        end

        def self.add( auth, groups )
          groups.each{ |group| group[:negative] = {exact: group.delete(:exact_negative), phrase: group.delete(:negative)} if group[:exact_negative] || group[:negative] }
          response = request( auth, Service, 'batchAdd', {groups: make_type( groups )} )
          process( response, 'groupIdList' ){ |x| x.map.with_index{|id, index| {id: id, name: groups[index][:name]}} }
        end

        # 奇虎组服务不提供批量delete和update方法
        def self.update( auth, group )
          group[0][:negative] = {exact: group[0].delete(:exact_negative), phrase: group[0].delete(:negative)}.to_json if group[0][:exact_negative] || group[0][:negative]
          params = make_type(group)[0]
          response = request( auth, Service, 'update', params )
          process( response, 'id' ){ |x| [{id: x, name: group[0][:name]}] }
        end

        def self.delete( auth, id )
          response = request( auth, Service, 'deleteById', {id: id[0]}  )
          process( response, 'affectedRecords' ){ |x| x == '1' }
        end

        def self.enable( auth, id )
          self.update(auth, [{id: id[0], pause: "enable"}])
        end

        def self.pause( auth, id )
          self.update(auth, [{id: id[0], pause: "pause"}])
        end

      end
    end
  end
end
