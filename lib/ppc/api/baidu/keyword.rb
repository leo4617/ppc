# -*- coding:utf-8 -*-
module PPC
  module API
    class Baidu
      class Keyword< Baidu
        Service = 'Keyword'

        Match_type  = { 'exact' => 1, 'pharse' => 2, 'wide' => 3 }
        Match_type_r  = { 1 => 'exact', 2=> 'pharse' , 3 => 'wide' }
        
        Device          = { 'pc' => 0, 'mobile' => 1, 'all' => 2 }
        Type              = { 'plan' => 3, 'group' => 5, 'keyword' => 11 }
        
        @map  = [
                            [:id,:keywordId],
                            [:group_id,:adgroupId],
                            [:keyword,:keyword],
                            [:price,:price],
                            [:pc_destination,:pcDestinationUrl],
                            [:mobile_destination,:mobileDestinationUrl],
                            [:match_type,:matchType],
                            [:phrase_type,:phraseType]
                        ]

        def self.add( auth, keywords, test = false )
          '''
          '''
          keywordtypes = make_type( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "addKeyword", body )
          return process(response, 'keywordTypes', test){|x| reverse_type(x)  }
        end

        def self.update( auth, keywords, test = false  )
          '''
          '''
          keywordtypes = make_type( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "updateKeyword", body )
          return process(response, 'keywordTypes', test){|x| reverse_type(x)  }
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
          return process(response, 'keywordTypes', test){|x| reverse_type(x)  }
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
        def self.status( auth, ids, type, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type]}
          response = request( auth, Service, 'getKeywordStatus', body )
          return process(response, 'keywordStatus', test){|x| x }
        end

        # 质量度评价标准即将被抛弃，此处失效
        # def self.quality( auth, ids, type, test  = false )
        #   '''
        #   这里百度开发文档和实际返回类型的关键字不同
        #   '''
        #   ids = [ ids ] unless ids.is_a? Array
        #   body = { ids: ids, type: Type[type]}
        #   response = request( auth, Service, 'getKeywordQuality', body )
        #   return process(response, 'qualities', test){|x| x }
        # end

        def self.quality( auth ,ids, type, device, test = false )
          '''
          Return 10Quanlity *Not the old Quality* of given ketword id
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type], device:Device[device] }
          response = request( auth, Service, 'getKeyword10Quality', body )
          return process(response, 'keyword10Quality', test){|x| x }
        end

        # Override
       def self.make_type( params, map = @map)
          params = [ params ] unless params.is_a? Array
          types = []
          params.each do |param|
            type = {}
              map.each do |key|
                # 增加对matchtype的自动转换
                if key[0] == :match_type
                   value = param[ key[0] ]
                  type[ key[1] ] = Match_type[ value ] if value                 
                else
                  value = param[ key[0] ]
                  type[ key[1] ] = value if value
                end
              end
            types << type
          end
          return types
        end

        # Overwrite
        def self.reverse_type( types, map = @map )
          types = [ types ] unless types.is_a? Array
          params = []
          types.each do |type|
            param = {}
             # 增加对matchtype的自动转换
              map.each do |key|
                if key[0] == :match_type
                   value = type[ key[1].to_s ]
                  param[ key[0] ] = Match_type_r[ value ] if value                 
                else
                  value = type[ key[0] ]
                  param[ key[0] ] = value if value
                end
              end # map.each
            params << param
          end # types.each
          return params
        end

      end # keyword
    end # Baidu
  end # API
end # PPC