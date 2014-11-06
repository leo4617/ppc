# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Creative< Qihu
        Service = 'creative'

        @map = [
                         [:id,:id] ,
                         [:group_id, :groupId],
                         [:title,:title],
                         [:description1, :description1],
                         [:description2, :description2],
                         [:pc_destination, :destinationUrl],
                         [:pc_display, :displayUrl]
                      ]

        @status_map = [ 
                                    [:id,:id], 
                                    [:quality,:qualityScore],
                                    [:status,:status]
                                  ]

        def self.get( auth, ids )
          body  = { 'idList' => to_json_string( ids ) }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'creativeList'){ |x| reverse_type( x['item'] ) }
        end

        def self.add( auth,  creatives )
          creative_types = make_type( creatives ).to_json
          body = { 'creatives' => creative_types}
          response = request( auth, Service, 'add', body )
          process( response, 'creativeIdList'){ |x| to_id_list( x['item'] ) }
        end

        def self.update( auth, creatives )
          creative_types = make_type( creatives ).to_json
          body = { 'creatives' => creative_types}
          response = request( auth, Service, 'update', body )
          process( response, 'affectedRecords', 'failCreativeIds' ){ |x| x }        
        end

         # 对update的再封装实现activate方法,未测试
        def self.activate( auth, ids )
          creatives = []
          ids.each{ |id| creatives << { id: id, status:'enable'} }
          update( auth, creatives )
        end       

        def self.delete( auth, ids )
          ids = to_json_string( ids )
          body = { 'idList' => ids }
          response = request( auth, Service, 'deleteByIdList', body )
          process( response, 'affectedRecords' ){ |x|x }     
        end

        def self.status( auth, ids )
          body = { idList: to_json_string( ids ) }
          response = request( auth, Service, 'getStatusByIdList', body )
          process( response, 'creativeList' ){ |x| reverse_type( x['item'], @status_map ) }     
        end

        # quality 本质上和 status 在一个方法里面
        def self.quality( auth, ids )
          status( auth, ids)
        end

        def self.search_id_by_group_id( auth, id, status = nil)
          # 处理条件  
          body = {}
          body['status'] = status if status
          body['groupId'] = id
          response = request( auth, Service, 'getIdListByGroupId', body )
          process( response, 'creativeIdList' ){ |x|  to_id_list( x['item'] )  }     
        end

        # combine two methods to provide another mether
        def self.search_by_group_id( auth, id )
          creative_ids = search_id_by_group_id( auth, id )
          get( auth , creative_ids )
        end

      end
    end
  end
end