# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Group < Qihu
        Service = 'group'

        GroupType = {
          id:           :id,
          plan_id:      :campaignId,
          status:       :status,
          name:         :name,
          price:        :price,
          # negateive为json格式，make_type要定制
          add_time:     :addTime,
          update_time:  :updateTime,
        }
        @map = GroupType

        # 再次封装提供all和ids
        def self.ids( auth )
          '''
          接口与其他的相同，但是无论如何：succ均为true，不返回任何错误信息
          因为是重复调用了search的接口，速度非常的慢，* 慎用 *
          '''
          plan_ids = ::PPC::API::Qihu::Plan::ids( auth )[:result]
          plan_group_ids = []

          plan_ids.each do |plan_id|
            plan_group_id = {}
            plan_group_id[:plan_id] = plan_id
            plan_group_id[:group_ids] = search_id_by_plan_id( auth, plan_id )[:result]
            plan_group_ids << plan_group_id
          end
          return { succ: true, failure:nil, result: plan_group_ids }
        end

        def self.all( auth )
          '''
          unimplemented due to ineffciency
          '''
          # unimplement
        end

        # 奇虎组服务不提供批量add,delete和update方法
        def self.add( auth, group )
          response = request( auth, Service, 'add', make_type( group )[0] )
          # 保证接口一致性
          process( response, 'id' ){ |x| [ { id:x.to_i } ]    }
        end

        def self.update( auth, group )
          if group[:negative] || group[:exact_negative]
            ng = {"exact" => group[:exact_negative], "phrase" => group[:negative]}.to_json
          end
          params = make_type(group)[0]
          params.merge!({:negativeWords => ng}) if ng
          response = request( auth, Service, 'update', params )
          # 保证接口一致性
          process( response, 'id' ){ |x|[ { id:x.to_i } ]  }
        end

        def self.get( auth, ids )
          ids = to_json_string( ids )
          body = { 'idList' => ids }
          response = request( auth, Service, 'getInfoByIdList', body  )
          process( response, 'groupList' ){ |x| reverse_type(x) }
        end

        def self.delete( auth, id )
          response = request( auth, Service, 'deleteById', { id: id}  )
          process( response, 'affectedRecords' ){ |x| x == '1' }
        end

        def self.search_id_by_plan_id( auth, id )
          response = request( auth, Service, 'getIdListByCampaignId', { 'campaignId' => id.to_s })
          #为了保持接口一致性，这里也是伪装成了百度的接口
          process( response, 'groupIdList' ){ 
            |x|
            [ { plan_id:id, group_ids: to_id_list(x) } ]
          }
        end

        # combine searchIdbyId and get to provide another method
        def self.search_by_plan_id( auth, id )
          group_ids = search_id_by_plan_id( auth, id )[:result][0][:group_ids]
          response = get( auth, group_ids )
          if response[:succ]
            response[:result] = [ { plan_id:id, groups:response[:result]}]
          end
          return response
        end

      end
    end
  end
end
