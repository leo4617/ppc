# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Keyword< Qihu
        Service = 'keyword'

        @map = [
                        [:id, :id],
                        [:group_id, :groupId],
                        [:keyword, :word],
                        [:price, :price],
                        [:match_type, :matchType],
                        [:pc_destination, :destinationUrl],
                        [:status, :status]
                      ]
        @status_map = [ 
                                    [:id,:id], 
                                    [:quality,:qualityScore],
                                    [:status,:status]
                                  ]

        def self.get( auth, ids )
          ids = to_json_string( ids )
          body  = { 'idList' => ids }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'keywordList'){ |x| reverse_type( x['item'] ) }
        end

        def self.add( auth,  keywords )
          keyword_types =  make_type( keywords ).to_json
          body = { 'keywords' => keyword_types}
          response = request( auth, Service, 'add', body )
          process( response, 'keywordIdList'){ |x| to_id_list( x['item'] )  }
        end

        def self.update( auth, keywords )
          keyword_types = JSON.generate( make_type( keywords ) )
          body = { 'keywords' => keyword_types}
          response = request( auth, Service, 'update', body )
          process( response, 'affectedRecords', 'failKeywordIds' ){ |x| x }        
        end

        def self.delete( auth, ids )
          body = { 'idList' => to_json_string( ids ) }
          response = request( auth, Service, 'deleteByIdList', body )
          process( response, 'affectedRecords' ){ |x|  x  }     
        end

        def self.search_id_by_group_id( auth, id, status = nil, match_type = nil )
          # 处理条件  
          body = {}
          body['status'] = status if status
          body['matchType'] = match_type if match_type
          body['groupId'] = id
          response = request( auth, Service, 'getIdListByGroupId', body )
          process( response, 'keywordIdList' ){ |x|to_id_list( x['item'] ) }     
        end

        def self.status( auth, ids )
          body = { idList: to_json_string( ids ) }
          response = request( auth, Service, 'getStatusByIdList', body )
          process( response, 'keywordList' ){ |x| reverse_type( x['item'], @status_map ) }     
        end

        def self.getChangedIdList
          # unimplemented
        end

      end
    end
  end
end