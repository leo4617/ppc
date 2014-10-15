# -*- coding:utf-8 -*-
module PPC
  module API
    module Baidu
      module Key
        include ::PPC::API::Baidu
        Service = 'Keyword'

        Match_type  = { 'exact' => 1, 'pharse' => 2, 'wide' => 3 }
        Device          = { 'pc' => 0, 'mobile' => 1, 'all' => 2 }
        Type              = { 'plan' => 3, 'group' => 5, 'key' => 11 }

        # introduce request to this namespace
        def self.request(auth, service, method, params = {} )
          ::PPC::API::Baidu::request(auth, service, method, params )
        end
        
        def self.add( auth, keywords, test = false )
          '''
          '''
          keywordtypes = make_keywordtype( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "addKeyword", body )
          return response if test else response['body']['keywordTypes']
        end

        def self.update( auth, keywords, test = false  )
          '''
          '''
          keywordtypes = make_keywordtype( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "updateKeyword", body )
          return response if test else response['body']['keywordTypes']
        end

        def self.delete( auth, ids, test = false )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids}
          response = request( auth, Service, 'deleteKeyword', body )
          return response if test else response['body']['result']
        end

        def self.activate( auth, ids, test =false )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids }
          response = request( auth, Service, 'activateKeyword', body)
          return response if test else response['body']['keywordTypes']
        end

        def self.search_by_group_id( auth, group_ids, test = false  )
          """
          getKeywordByGroupId
          @input: list of group id
          @output:  list of groupKeyword
          """
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { adgroupIds: group_ids }
          response = request( auth, Service, "getKeywordByAdgroupId", body )
          return response if test else response['body']['groupKeywordIds']
        end

        # 下面三个操作操作对象包括计划，组和关键字
        # 不知道放在这里合不合适
        def self.get_status( auth, ids, type, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type]}
          response = request( auth, Service, 'getKeywordStatus', body )
          return response if test else response['body']['keywordStatus']
        end

        def self.get_quality( auth, ids, type, test  = false )
          '''
          这里百度开发文档和实际返回类型的关键字不同
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type]}
          response = request( auth, Service, 'getKeywordQuality', body )
          return response if test else response['body']['qualities']
        end

        def self.get_10quality( auth ,ids, type, device, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type], device:Device[device] }
          response = request( auth, Service, 'getKeyword10Quality', body )
          return response if test else response['body']['keyword10Quality']
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
            keywordttype[:keyword]                        =    param[:key]                   if     param[:key]
            keywordttype[:Price]                               =    param[:price]                     if    param[:price]
            keywordttype[:pcDestinationUrl]            =     param[:pc_destination]         if     param[:pc_destination] 
            keywordttype[:mobileDestinationUrl]    =     param[:moile_destination]   if     param[:moile_destination]
            keywordttype[:matchType]                      =     match_type                              if    match_type
            keywordttype[:phraseType]                     =    param[:phrase_type]              if    param[:phrase_type]
            keywordttype[:pause]                              =    param[:pause]                          if    param[:pause]
          
            keywordttypes << keywordttype
          end
          return keywordttypes
        end # make_keywordtype

      end # key
    end # Baidu
  end # API
end # PPC