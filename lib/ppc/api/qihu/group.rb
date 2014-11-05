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

        def self.add( auth, group )
          response = request( auth, Service, 'add', make_type( group )[0] )
          process( response, 'id' ){ |x| x  }
        end
        
        def self.update( auth, group )
          response = request( auth, Service, 'update', make_type( group )[0]  )
          process( response, 'id' ){ |x| x  }
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
          process( response, 'groupIdList' ){ |x| x['item'] }
        end

      end
    end
  end
end