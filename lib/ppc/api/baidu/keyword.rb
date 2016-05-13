# -*- coding:utf-8 -*-
module PPC
  module API
    class Baidu
      class Keyword< Baidu
        Service = 'Keyword'

        Device      = { 'pc' => 0, 'mobile' => 1, 'all' => 2 }
        Type        = { 'plan' => 3, 'group' => 5, 'keyword' => 11 }
        
        KeywordType  = {
          id:                 :keywordId,
          group_id:           :adgroupId,
          plan_id:            :campaignId,
          keyword:            :keyword,
          price:              :price,
          pc_destination:     :pcDestinationUrl,
          mobile_destination: :mobileDestinationUrl,
          match_type:         :matchType,
          phrase_type:        :phraseType,
          status:             :status,
          pause:              :pause,
          wmatchprefer:       :wmatchprefer,
        }
        @map = KeywordType

        KeywordQualityType = {
          id:               :id,
          group_id:         :adgroupId,
          plan_id:          :campaignId,
          pc_quality:       :pcQuality,
          pc_reliable:      :pcReliable,
          pc_reason:        :pcReason,
          pc_scale:         :pcScale,
          mobile_quality:   :mobileQuality,
          mobile_reliable:  :mobileReliable,
          mobile_reason:    :mobileReason,
          mobile_scale:     :mobileScale,
        }
        @quality10_map = KeywordQualityType

        # 后面改成info方法
        def self.get( auth, ids )
          '''
          getKeywordByKeywordId
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids}
          response = request( auth, Service, 'getKeywordByKeywordId', body )
          return process(response, 'keywordTypes' ){|x| reverse_type( x ) }
        end

        def self.add( auth, keywords )
          '''
          '''
          keywordtypes = make_type( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "addKeyword", body )
          return process(response, 'keywordTypes' ){|x| reverse_type(x)  }
        end

        def self.update( auth, keywords  )
          '''
          '''
          keywordtypes = make_type( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "updateKeyword", body )
          return process(response, 'keywordTypes' ){|x| reverse_type(x)  }
        end

        def self.delete( auth, ids )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids}
          response = request( auth, Service, 'deleteKeyword', body )
          return process(response, 'result' ){|x| x }
        end

        def self.activate( auth, ids )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids }
          response = request( auth, Service, 'activateKeyword', body)
          return process(response, 'keywordTypes' ){|x| reverse_type(x)  }
        end

        def self.search_by_group_id( auth, group_ids  )
          """
          getKeywordByGroupIds
          @input: list of group id
          @output:  list of groupKeyword
          """
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { adgroupIds: group_ids }
          response = request( auth, Service, "getKeywordByAdgroupId", body )
          return process(response, 'groupKeywords' ){|x| make_groupKeywords( x ) }
        end

        def self.search_id_by_group_id( auth, group_ids  )
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { adgroupIds: group_ids }
          response = request( auth, Service, "getKeywordIdByAdgroupId", body )
          return process(response, 'groupKeywordIds' ){|x| make_groupKeywordIds( x ) }
        end

        # 下面三个操作操作对象包括计划，组和关键字
        # 不知道放在这里合不合适
        def self.status( auth, ids, type )
          '''
          Return [{ id: id, status: status } ... ]
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type]}
          response = request( auth, Service, 'getKeywordStatus', body )
          return process(response, 'keywordStatus' ){  |statusTypes| 
            statusTypes = [statusTypes] unless statusTypes.is_a? Array
            status =[]

            statusTypes.each do |statusType|
              status << { id: statusType['id'], status: statusType['status'] }
            end
            return status
           }
        end

        def self.quality( auth ,ids, type, device )
          '''
          Return 10Quanlity *Not the old Quality* of given ketword id
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type], device:Device[device] }
          response = request( auth, Service, 'getKeyword10Quality', body )
          return process(response, 'keyword10Quality' ){|x| reverse_type( x, @quality10_map ) }
        end

        private
        def self.make_groupKeywordIds( groupKeywordIds )
          group_keyword_ids = []
          groupKeywordIds.each do |groupKeywordId|
            group_keyword_id = { }
            group_keyword_id[:group_id] = groupKeywordId['adgroupIds']
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
    end # Baidu
  end # API
end # PPC
