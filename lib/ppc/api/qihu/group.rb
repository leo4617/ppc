# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Group < Qihu
        Service = 'group'

        @map = [
                        [:id, :id ],
                        [:status, :status ],
                        [:name, :name ],
                        [:price, :price ],
                        # negateive为json格式，make_type要定制
                        [:negative, :negativeWords ]
                      ]

        def self.add( gourp )
          response = request( auth, Service, 'add', make_type( group ))
          process( response, 'group_add_response' ){ |x| x ['id'] }
        end
        
        def sel.update( group )
          response = request( auth, Service, 'update', make_type( group ))
          process( response, 'group_update_response' ){ |x| x ['id'] }
        end

        def self.get( ids )
          ids = [ids] unless ids.is_a? Array
          ids_str = []
          ids.each{ |x| ids_str << x.to_s }
          body = { 'idList' => JSON.generate( ids_str )}
          response = request( auth, Service, 'update', body  )
          process( response, 'group_getInfoByIdList_response' ){ |x| reverse_type( x['groupList']['item'] }
        end

        def self.delete( id )
          response = request( auth, Service, 'deleteById', body  )
          process( response, 'group_deleteById_response' ){ |x| x }
        end
      
        def self.search_id_by_plan_id( ids )
          response = request( auth, Service, 'getIdListByCampaignId', { 'campaignId' => id.to_s })
          process( response, 'getIdListByCampaignId' ){ |x| x['groupIdList']['item'] }
        end
      end
    end
  end
end