# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Group < Qihu
        Service = 'group'

        @map = [
                        [:id, :id ],
                        [:plan_id, :campaignId],
                        [:status, :status ],
                        [:name, :name ],
                        [:price, :price ],
                        # negateive为json格式，make_type要定制
                        [:negative, :negativeWords ],
                        [:add_time, :addTime],
                        [:update_time, :updateTime]
                      ]

        # 奇虎组服务不提供批量add,delete和update方法
        def self.add( auth, group )
          response = request( auth, Service, 'add', make_type( group )[0] )
          process( response, 'id' ){ |x| x.to_i  }
        end
        
        def self.update( auth, group )
          response = request( auth, Service, 'update', make_type( group )[0]  )
          process( response, 'id' ){ |x| x.to_i  }
        end

        def self.get( auth, ids )
          ids = to_json_string( ids )
          body = { 'idList' => ids }
          response = request( auth, Service, 'getInfoByIdList', body  )
          process( response, 'groupList' ){ |x| reverse_type( x['item'] ) }
        end

        def self.delete( auth, id )
          response = request( auth, Service, 'deleteById', { id: id}  )
          process( response, 'affectedRecords' ){ |x| x == '1' }
        end
      
        def self.search_id_by_plan_id( auth, id )
          response = request( auth, Service, 'getIdListByCampaignId', { 'campaignId' => id.to_s })
          process( response, 'groupIdList' ){ |x| to_id_list( x['item'] ) }
        end

        # combine searchIdbyId and get to provide another method
        def self.search_by_plan_id( auth, id )
          group_ids = search_id_by_plan_id( auth, id )
          get( auth, group_ids )
        end

      end
    end
  end
end