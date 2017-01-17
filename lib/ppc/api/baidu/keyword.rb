# -*- coding:utf-8 -*-
module PPC
  module API
    class Baidu
      class Keyword< Baidu
        Service = 'Keyword'

        Match_type  = { 'exact' => 1, 'phrase' => 2, 'wide' => 3,1 => 'exact', 2=> 'phrase' , 3 => 'wide'  }
        @match_types = Match_type
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

        def self.info( auth, ids )
          body = { ids: ids, idType: 11, wordFields: KeywordType.values}
          response = request( auth, Service, 'getWord', body )
          process(response, 'keywordType' ){|x| reverse_type( x )[0] }
        end

        def self.all( auth, group_ids )
          body = { ids: group_ids, idType: 5, wordFields: KeywordType.values}
          response = request( auth, Service, 'getWord', body )
          process(response, 'groupKeywords' ){|x| reverse_type( x ) }
        end

        def self.ids( auth, group_ids )
          body = { ids: group_ids, idType: 5, wordFields: [:keywordId]}
          response = request( auth, Service, 'getWord', body )
          process(response, 'groupKeywordIds' ){|x| reverse_type( x ) }
        end

        def self.get( auth, ids )
          body = { ids: ids, idType: 11, wordFields: KeywordType.values}
          response = request( auth, Service, 'getWord', body )
          process(response, 'keywordTypes' ){|x| reverse_type( x ) }
        end

        def self.add( auth, keywords )
          body = { keywordTypes: make_type( keywords ) }
          response = request( auth, Service, "addWord", body )
          process(response, 'keywordTypes' ){|x| reverse_type(x)  }
        end

        def self.update( auth, keywords  )
          body = { keywordTypes: make_type( keywords ) }
          response = request( auth, Service, "updateWord", body )
          process(response, 'keywordTypes' ){|x| reverse_type(x)  }
        end

        def self.delete( auth, ids )
          body = { keywordIds: ids}
          response = request( auth, Service, 'deleteWord', body )
          process(response, 'result' ){|x| x }
        end

        def self.enable( auth, ids )
          keywords = ids.map{|id| {id: id, pause: false} }
          self.update( auth, keywords )
        end

        def self.pause( auth, ids )
          keywords = ids.map{|id| {id: id, pause: true} }
          self.update( auth, keywords )
        end

        def self.status( auth, ids )
          body = { ids: ids, idType: 11, keywordTypes: [:keywordId, :status]}
          response = request( auth, Service, 'getWord', body )
          process(response, 'groupKeywords' ){|x| reverse_type( x ) }
        end

        def self.quality( auth, ids )
          body = { ids: ids, idType: 11, keywordTypes: KeywordQualityType.values}
          response = request( auth, Service, 'getWord', body )
          process(response, 'groupKeywords' ){|x| reverse_type( x , KeywordQualityType) }
        end

        def self.search( auth, params )
          body = { 
            searchWord:   params[:keyword],
            startNum:     1,
            endNum:       1000,
            searchLevel:  2,
            searchType:   1,
          }
          body.merge!(campaignId: params[:plan_id])   if params[:plan_id]
          body.merge!(adgroupId:  params[:group_id])  if params[:group_id]
          response = request( auth, "Search", 'getMaterialInfoBySearch', body )
          process(response, 'materialSearchInfos' ){|x| x[0]["materialSearchInfos"].map{|tmp| tmp["materialInfos"]} }
        end

      end # keyword
    end # Baidu
  end # API
end # PPC
