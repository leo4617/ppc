# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Keyword< Qihu
        Service = 'keyword'

        KeywordType = {
          id:                 :id,
          group_id:           :groupId,
          keyword:            :word,
          price:              :price,
          match_type:         :matchType,
          pc_destination:     :url,
          mobile_destination: :mobileUrl,
          pause:              :status,
        }
        @map = KeywordType

        @status_map = {
          id:                   :id,
          pc_quality:           :qualityScore,
          mobile_quality:       :mobileQualityScore,
          pause:                :status,
          mobile_pause:         :mobileStatus,
          pc_lowest_price:      :pcLowestPrice,
          mobile_lowest_price:  :mobileLowestPrice,
        }

        def self.info( auth, ids )
          body  = { 'idList' => ids.map(&:to_s) }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'keywordList'){ |x| reverse_type(x)[0] }
        end

        # combine search_id and get to provide another method
        def self.all( auth, id )
          keyword_ids = self.ids( auth, id )[:result][0][:keyword_ids]
          response = get( auth, keyword_ids )
          response[:result] = [ { group_id:id, keywords:response[:result] } ] if response[:succ]
          response
        end

        def self.ids( auth, id )
          response = request( auth, Service, 'getIdListByGroupId', {'groupId' => id[0]} )
          process( response, 'keywordIdList' ){ |x| {group_id:id, keyword_ids: x.map(&:to_i) } }
        end

        def self.get( auth, ids )
          body  = { 'idList' => ids.map(&:to_s) }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'keywordList'){ |x| reverse_type(x) }
        end

        def self.add( auth,  keywords )
          body = { 'keywords' => make_type( keywords ).to_json}
          response = request( auth, Service, 'add', body )
          process( response, 'keywordIdList'){ |x| x.map{|tmp| { id: i.to_i } } }
        end

        def self.update( auth, keywords )
          body = { 'keywords' => make_type( keywords ).to_json}
          response = request( auth, Service, 'update', body )
          process( response, 'affectedRecords', 'failKeywordIds' ){ |x| x }
        end

        def self.delete( auth, ids )
          body = { 'idList' => ids.map(&:to_s) }
          response = request( auth, Service, 'deleteByIdList', body )
          process( response, 'affectedRecords' ){ |x|  x  }     
        end

        def self.enable( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, status:'enable'} } )
        end

        def self.pause( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, status:'pause'} } )
        end

        def self.status( auth, ids )
          body = { idList: ids.map(&:to_s) }
          response = request( auth, Service, 'getStatusByIdList', body )
          process( response, 'keywordList' ){ |x| reverse_type(x, @status_map) }
        end

        # quality 本质上和 status 在一个方法里面
        def self.quality( auth, ids )
          self.status( auth, ids)
        end

        def self.getChangedIdList
          # unimplemented
        end

      end
    end
  end
end
