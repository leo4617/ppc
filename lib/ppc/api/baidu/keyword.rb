# -*- coding:utf-8 -*-
module PPC
  module API
    class Baidu
      class Keyword< Baidu
        Service = 'Keyword'

        Match_type  = { 'exact' => 1, 'pharse' => 2, 'wide' => 3,1 => 'exact', 2=> 'pharse' , 3 => 'wide'  }
        
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
                            [:phrase_type,:phraseType],
                            [:status,:status],
                            [:pause,:pause]
                        ]

        @quality10_map = [
                                          [ :id, :id ],
                                          [ :group_id, :adgroupId ],
                                          [ :plan_id, :Campaigned ],
                                          [ :pc_quality, :pcQuality ],
                                          [ :pc_reliable, :pcReliable ],
                                          [ :pc_reason, :pcReason ],
                                          [ :pc_scale, :pcScale ],
                                          [ :mobile_quality, :mobileQuality ],
                                          [ :mobile_reliable, :mobileReliable ],
                                          [ :mobile_reason, :mobileReason ],
                                          [ :mobile_scale, :mobileScale ]
                                        ]

        # 后面改成info方法
        def self.get( auth, ids, debug = false )
          '''
          getKeywordByKeywordId
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids}
          response = request( auth, Service, 'getKeywordByKeywordId', body )
          return process(response, 'keywordTypes', debug){|x| reverse_type( x ) }
        end

        def self.add( auth, keywords, debug = false )
          '''
          '''
          keywordtypes = make_type( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "addKeyword", body )
          return process(response, 'keywordTypes', debug){|x| reverse_type(x)  }
        end

        def self.update( auth, keywords, debug = false  )
          '''
          '''
          keywordtypes = make_type( keywords ) 
          body = { keywordTypes: keywordtypes }
          response = request( auth, Service, "updateKeyword", body )
          return process(response, 'keywordTypes', debug){|x| reverse_type(x)  }
        end

        def self.delete( auth, ids, debug = false )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids}
          response = request( auth, Service, 'deleteKeyword', body )
          return process(response, 'result', debug){|x| x }
        end

        def self.activate( auth, ids, debug =false )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { keywordIds: ids }
          response = request( auth, Service, 'activateKeyword', body)
          return process(response, 'keywordTypes', debug){|x| reverse_type(x)  }
        end

        def self.search_by_group_id( auth, group_ids, debug = false  )
          """
          getKeywordByGroupIds
          @input: list of group id
          @output:  list of groupKeyword
          """
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { adgroupIds: group_ids }
          response = request( auth, Service, "getKeywordByAdgroupId", body )
          return process(response, 'groupKeywords', debug){|x| make_groupKeywords( x ) }
        end

        def self.search_id_by_group_id( auth, group_ids, debug = false  )
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { adgroupIds: group_ids }
          response = request( auth, Service, "getKeywordIdByAdgroupId", body )
          return process(response, 'groupKeywordIds', debug){|x| make_groupKeywordIds( x ) }
        end

        # 下面三个操作操作对象包括计划，组和关键字
        # 不知道放在这里合不合适
        def self.status( auth, ids, type, debug = false )
          '''
          Return [{ id: id, status: status } ... ]
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type]}
          response = request( auth, Service, 'getKeywordStatus', body )
          return process(response, 'keywordStatus', debug){  |statusTypes| 
            statusTypes = [statusTypes] unless statusTypes.is_a? Array
            status =[]

            statusTypes.each do |statusType|
              status << { id: statusType['id'], status: statusType['status'] }
            end
            return status
           }
        end

        def self.quality( auth ,ids, type, device, debug = false )
          '''
          Return 10Quanlity *Not the old Quality* of given ketword id
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, type: Type[type], device:Device[device] }
          response = request( auth, Service, 'getKeyword10Quality', body )
          return process(response, 'keyword10Quality', debug){|x| reverse_type( x, @quality10_map ) }
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
                  param[ key[0] ] = Match_type[ value ] if value                 
                else
                  value = type[ key[1].to_s ]
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