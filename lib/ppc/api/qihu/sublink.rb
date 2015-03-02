# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Sublink< Qihu
        Service = 'sublink'

        @map = [
                 [:id,:id] ,
                 [:group_id, :groupId],
                 [:anchor,:text],
                 [:url, :link],
                 [:image, :image],
                 [:status, :status]
                ]

        def self.get( auth, ids )
          body  = { 'idList' => to_json_string( ids ) }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'sublinkList'){ |x| reverse_type( x['item'] ) }
        end

        def self.add( auth, sublinks )
          sublink_types = make_type( sublinks ).to_json
          body = { 'sublinks' => sublink_types}
          response = request( auth, Service, 'add', body )
          process( response, 'sublinkIdList'){ |x| to_id_hash_list( x['item'] ) }
        end

        # helper function for self.add() method
        private
        def self.to_id_hash_list( str )
          reuturn [] if str == nil
          str = [str] unless str.is_a?Array
          x= []
          str.each{ |i| x << { id: i.to_i } }
          return x
        end

        def self.update( auth, sublinks )
          sublink_types = make_type( creatives ).to_json
          body = { 'sublinks' => sublink_types}
          response = request( auth, Service, 'update', body )
          process( response, 'affectedRecords', 'failKeywordIds' ){ |x| x }        
        end

         # 对update的再封装实现activate方法,未测试
        def self.activate( auth, ids )
          sublinks = []
          ids.each{ |id| sublinks << { id: id, status:'enable'} }
          update( auth, sublinks )
        end       

        def self.delete( auth, ids )
          ids = to_json_string( ids )
          body = { 'idList' => ids }
          response = request( auth, Service, 'deleteByIdList', body )
          process( response, 'affectedRecords' ){ |x|x }     
        end

        def self.search_id_by_group_id( auth, id, status = nil)
          # 处理条件  
          body = {}
          body['status'] = status if status
          body['groupId'] = id
          response = request( auth, Service, 'getIdListByGroupId', body )
          # 伪装成百度接口
          process( response, 'creativeIdList' ){ 
            |x|  
            [ { group_id:id, creative_ids:to_id_list( x==nil ? nil: x['item'] ) } ] 
          }     
        end

        # combine two methods to provide another mether
        def self.search_by_group_id( auth, id )
          creative_ids = search_id_by_group_id( auth, id )
          response = get( auth , creative_ids )
          # 伪装成百度接口
          if response[:succ]
            response[:result] = [ { group_id:id, creatives:response[:result ] } ]
          end
          return response
        end

      end
    end
  end
end
