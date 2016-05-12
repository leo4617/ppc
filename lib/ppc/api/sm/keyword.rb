# -*- coding:utf-8 -*-
module PPC
  module API
    class Sm
      class Keyword < Sm
        Service = 'keyword'
        
        KeywordType = {
          id:                 :keywordId,
          group_id:           :adgroupId,
          keyword:            :keyword,
          price:              :price,
          mobile_destination: :destinationUrl,
          match_type:         :matchType,
          status:             :status,
          pause:              :pause,
        }
        @map = KeywordType

        def self.get(auth, ids)
          ids = [ids] unless ids.is_a? Array
          body = {keywordIds: ids}
          response = request(auth, Service, 'getKeywordByKeywordId', body)
          return process(response, 'keywordTypes'){|x| reverse_type(x)}
        end

        def self.add(auth, keywords)
          keyword_types = make_type(keywords) 
          body = {keywordTypes: keyword_types}
          response = request(auth, Service, "addKeyword", body)
          return process(response, 'keywordTypes'){|x| reverse_type(x)}
        end

        def self.update(auth, keywords)
          keyword_types = make_type(keywords) 
          body = {keywordTypes: keyword_types}
          response = request(auth, Service, "updateKeyword", body)
          return process(response, 'keywordTypes'){|x| reverse_type(x)}
        end

        def self.delete(auth, ids)
          ids = [ids] unless ids.is_a? Array
          body = {keywordIds: ids}
          response = request(auth, Service, 'deleteKeyword', body, 'delete')
          return process(response, 'result'){|x| x }
        end

        def self.search_by_group_id(auth, group_ids)
          group_ids = [group_ids] unless group_ids.is_a? Array
          body = {adgroupIds: group_ids}
          response = request(auth, Service, "getKeywordByAdgroupId", body)
          return process(response, 'groupKeywords'){|x| make_groupKeywords(x)}
        end

        def self.search_id_by_group_id(auth, group_ids)
          group_ids = [group_ids] unless group_ids.is_a? Array
          body = {adgroupIds: group_ids}
          response = request(auth, Service, "getKeywordIdByAdgroupId", body)
          return process(response, 'groupKeywordIds'){|x| make_groupKeywordIds(x)}
        end

        private
        def self.make_groupKeywordIds( groupKeywordIds )
          group_keyword_ids = []
          groupKeywordIds.each do |groupKeywordId|
            group_keyword_id = { }
            group_keyword_id[:group_id] = groupKeywordId['adgroupId']
            group_keyword_id[:keyword_ids] = groupKeywordId['keywordIds']
            group_keyword_ids << group_keyword_id
          end
          return group_keyword_ids
        end

        private
        def self.make_groupKeywords( groupKeywords )
          group_keywords = []
          groupKeywords.each do |groupKeyword|
            group_keyword = {}
            group_keyword[:group_id] = groupKeyword['adgroupId']
            group_keyword[:keywords] = reverse_type( groupKeyword['keywordTypes'] )
            group_keywords << group_keyword
          end
          return group_keywords
        end

      end # keyword
    end # Sm
  end # API
end # PPC
