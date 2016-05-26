# -*- coding:utf-8 -*-
module PPC
  module API
    class Sm
      class Keyword < Sm
        Service = 'keyword'
        
        Match_type  = { 'exact' => 0, 'phrase' => 1, 'wide' => 2, 0 => 'exact', 1 => 'phrase' , 2 => 'wide'  }
        @match_types = Match_type
        KeywordType = {
          id:                 :keywordId,
          group_id:           :adgroupId,
          keyword:            :keyword,
          price:              :price,
          mobile_destination: :destinationUrl,
          match_type:         :matchType,
          status:             :status,
          pause:              :pause,
          keyword_ids:        :keywordIds,
          keywords:           :keywordTypes,
        }
        @map = KeywordType

        def self.info(auth, ids)
          response = request(auth, Service, 'getKeywordByKeywordId', {keywordIds: ids})
          process(response, 'keywordTypes'){|x| reverse_type(x)[0] }
        end

        def self.all(auth, group_ids)
          response = request(auth, Service, "getKeywordByAdgroupId", {adgroupIds: group_ids} )
          process(response, 'groupKeywords'){|x| reverse_type( x.map{|temp| temp["keywordTypes"]}.flatten ) }
        end

        def self.ids(auth, group_ids)
          response = request(auth, Service, "getKeywordIdByAdgroupId", {adgroupIds: group_ids} )
          process(response, 'groupKeywordIds'){|x| reverse_type(x)}
        end

        def self.get(auth, ids)
          response = request(auth, Service, 'getKeywordByKeywordId', {keywordIds: ids})
          process(response, 'keywordTypes'){|x| reverse_type(x)}
        end

        def self.add(auth, keywords)
          body = {keywordTypes: make_type(keywords) }
          response = request(auth, Service, "addKeyword", body)
          process(response, 'keywordTypes'){|x| reverse_type(x)}
        end

        def self.update(auth, keywords)
          body = {keywordTypes: make_type(keywords) }
          response = request(auth, Service, "updateKeyword", body)
          process(response, 'keywordTypes'){|x| reverse_type(x)}
        end

        def self.delete(auth, ids)
          response = request(auth, Service, 'deleteKeyword', {keywordIds: ids}, 'delete')
          process(response, 'result'){|x| x }
        end

        def self.enable( auth, ids )
          keywords = ids.map{|id| {id: id, pause: false} }
          self.update( auth, keywords )
        end

        def self.pause( auth, ids )
          keywords = ids.map{|id| {id: id, pause: true} }
          self.update( auth, keywords )
        end

      end # keyword
    end # Sm
  end # API
end # PPC
