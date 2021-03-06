# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Keyword< Qihu
        Service = 'keyword'

        KeywordType = {
          id:                     :id,
          group_id:               :groupId,
          keyword:                :word,
          price:                  :price,
          match_type:             :matchType,
          pc_destination:         :url,
          "pc_destination"     => :destinationUrl,
          mobile_destination:     :mobileUrl,
          "mobile_destination" => :mobileDestinationUrl,
          pause:                  :status,
          mobile_pause:           :mobileStatus,
          add_time:               :addTime,
          update_time:            :updateTime,
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
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'keywordList'){ |x| reverse_type(x)[0] }
        end

        # combine search_id and get to provide another method
        def self.all( auth, group_id )
          results = self.ids( auth, group_id )
          return results unless results[:succ]
          self.get( auth , results[:result] )
        end

        def self.ids( auth, group_id )
          response = request( auth, Service, 'getIdListByGroupId', {'groupId' => group_id[0]} )
          process( response, 'keywordIdList' ){ |x| x.map(&:to_i) }
        end

        def self.get( auth, ids )
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'keywordList'){ |x| reverse_type(x) }
        end

        def self.add( auth,  keywords )
          response = request( auth, Service, 'add', { keywords: make_type( keywords )} )
          process( response, 'keywordIdList'){ |x| x.map.with_index{|id, index| {id: id, keyword: keywords[index][:word]}} }
        end

        def self.update( auth, keywords )
          response = request( auth, Service, 'update', { keywords: make_type( keywords )} )
          process( response, 'affectedRecords', 'failKeywordIds' ){ |x| x == keywords.size ? keywords.map{|keyword| {id: keyword[:id]}} : nil }
        end

        def self.delete( auth, ids )
          response = request( auth, Service, 'deleteByIdList', { idList: ids } )
          process( response, 'affectedRecords' ){ |x|  x == keywords.size ? keywords.map{|keyword| {id: keyword[:id]}} : nil  }     
        end

        def self.enable( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, pause:'enable'} } )
        end

        def self.pause( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, pause:'pause'} } )
        end

        def self.status( auth, ids )
          response = request( auth, Service, 'getStatusByIdList', { idList: ids } )
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
