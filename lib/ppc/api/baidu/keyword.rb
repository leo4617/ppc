# -*- coding:utf-8 -*-
module PPC
  module API
    class Baidu
      class Keyword< Baidu
        Service = 'Keyword'

        Match_type  = { 'exact' => 1, 'pharse' => 2, 'wide' => 3 }
        Device          = { 'pc' => 0, 'mobile' => 1, 'all' => 2 }
        Type              = { 'plan' => 3, 'group' => 5, 'keyword' => 11 }
        
        def self.add( auth, keywords, test = false )
          '''
          '''
          keywordtypes = make_keywordtype( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "addKeyword", body )
          return process(response, 'keywordTypes', test){|x| reverse_keywordtype(x)  }
        end

        def self.update( auth, keywords, test = false  )
          '''
          '''
          keywordtypes = make_keywordtype( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "updateKeyword", body )
          return process(response, 'keywordTypes', test){|x| reverse_keywordtype(x)  }
        end

        def self.delete( auth, ids, test = false )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids}
          response = request( auth, Service, 'deleteKeyword', body )
          return process(response, 'result', test){|x| x }
        end

        def self.activate( auth, ids, test =false )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids }
          response = request( auth, Service, 'activateKeyword', body)
          return process(response, 'keywordTypes', test){|x| reverse_keywordtype(x)  }
        end

        def self.search_by_group_id( auth, group_ids, test = false  )
          """
          getKeywordByGroupIds
          @input: list of group id
          @output:  list of groupKeyword
          """
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { adgroupIds: group_ids }
          response = request( auth, Service, "getKeywordByAdgroupId", body )
          return process(response, 'groupKeywordIds', test){|x| x }
        end

        # 下面三个操作操作对象包括计划，组和关键字
        # 不知道放在这里合不合适
        def self.get_status( auth, ids, type, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type]}
          response = request( auth, Service, 'getKeywordStatus', body )
          return process(response, 'keywordStatus', test){|x| x }
        end

        def self.get_quality( auth, ids, type, test  = false )
          '''
          这里百度开发文档和实际返回类型的关键字不同
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type]}
          response = request( auth, Service, 'getKeywordQuality', body )
          return process(response, 'qualities', test){|x| x }
        end

        def self.get_10quality( auth ,ids, type, device, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type], device:Device[device] }
          response = request( auth, Service, 'getKeyword10Quality', body )
          return process(response, 'keyword10Quality', test){|x| x }
        end

        private
        def self.make_keywordtype( params )
          '''
          '''
          params = [ params ] unless params.is_a? Array
          keywordttypes = []

          params.each do  |param| 
            keywordttype = {}
            
            match_type = false
            match_type = Match_type[ param[:match_type] ] if param[:match_type] 

            keywordttype[:keywordId]                     =    param[:id]                          if     param[:id]
            keywordttype[:adgroupId]                     =    param[:group_id]                if     param[:group_id]  
            keywordttype[:keyword]                        =    param[:keyword]                   if     param[:keyword]
            keywordttype[:price]                               =    param[:price]                     if    param[:price]
            keywordttype[:pcDestinationUrl]            =     param[:pc_destination]         if     param[:pc_destination] 
            keywordttype[:mobileDestinationUrl]    =     param[:mobile_destination]   if     param[:mobile_destination]
            keywordttype[:matchType]                      =     match_type                              if    match_type
            keywordttype[:phraseType]                     =    param[:phrase_type]              if    param[:phrase_type]
            keywordttype[:pause]                              =    param[:pause]                          if    param[:pause]
          
            keywordttypes << keywordttype
          end
          return keywordttypes
        end # make_keywordtype

        private 
        def self.reverse_keywordtype( keywordttypes )
          keyword_apis = []
          keywordttypes.each do |keywordttype|
            keyword_api = {}
            keyword_api[:id]                                   = keywordttype['keywordId']  if keywordttype['keywordId']
            keyword_api[:group_id]                       = keywordttype['adgroupId']  if keywordttype['adgroupId']
            keyword_api[:keyword]                       = keywordttype['keyword']  if keywordttype['keyword']
            keyword_api[:price]                              = keywordttype['price']  if keywordttype['price']
            keyword_api[:pc_destination]             = keywordttype['pcDestinationUrl']  if keywordttype['pcDestinationUrl']
            keyword_api[:mobile_destination]    = keywordttype['mobileDestinationUrl']  if keywordttype['mobileDestinationUrl']
            keyword_api[:match_type]                  = keywordttype['matchType']  if keywordttype['matchType']
            keyword_api[:phrase_type]                 = keywordttype['phraseType']  if keywordttype['phraseType']
            keyword_api[:pause]                            = keywordttype['pause']  if keywordttype['pause']
            keyword_apis << keyword_api
          end
          reutrn keyword_apis
        end

      end # keyword
    end # Baidu
  end # API
end # PPC