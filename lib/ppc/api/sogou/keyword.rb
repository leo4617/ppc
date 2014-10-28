# -*- coding:utf-8 -*-
module PPC
  module API
    class Sogou
      class Keyword< Sogou
        Service = 'Keyword'

        Match_type  = { 'exact' => 0, 'wide' => 1 }
        Match_type_r  = { 0 => 'exact', 1 => 'wide' }
        
        # Device          = { 'pc' => 0, 'mobile' => 1, 'all' => 2 }
        # Type              = { 'plan' => 3, 'group' => 5, 'keyword' => 11 }
        
        @map  = [
                            [:id,:cpcId],
                            [:group_id,:cpcGrpId],
                            [:keyword,:cpc],
                            [:price,:price],
                            [:pc_destination,:visitUrl],
                            [:mobile_destination,:mobileVisitUrl],
                            [:match_type,:matchType],
                            [:pause,:pause],
                            [:status,:status],
                            [:quality,:cpcQuality]
                        ]

        # @quality10_map = [
        #                                   [ :id, :id ],
        #                                   [ :group_id, :adgroupId ],
        #                                   [ :plan_id, :Campaigned ],
        #                                   [ :pc_quality, :pcQuality ],
        #                                   [ :pc_reliable, :pcReliable ],
        #                                   [ :pc_reason, :pcReason ],
        #                                   [ :pc_scale, :pcScale ],
        #                                   [ :mobile_quality, :mobileQuality ],
        #                                   [ :mobile_reliable, :mobileReliable ],
        #                                   [ :mobile_reason, :mobileReason ],
        #                                   [ :mobile_scale, :mobileScale ]
        #                                 ]

        # 后面改成info方法
        def self.get( auth, ids, debug = false )
          '''
          getCpcByCpcId
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcIds: ids}
          response = request( auth, Service, 'getCpcByCpcId', body )
          return process(response, 'cpcTypes', debug){|x| reverse_type( x ) }
        end

        def self.add( auth, keywords, debug = false )
          '''
          '''
          cpcTypes = make_type( keywords ) 
          body = { cpcTypes: cpcTypes }
          response = request( auth, Service, "addCpc", body )
          return process(response, 'cpcTypes', debug){|x| reverse_type(x)  }
        end

        def self.update( auth, keywords, debug = false  )
          '''
          '''
          cpcTypes = make_type( keywords ) 
          body = { cpcTypes: cpcTypes }
          response = request( auth, Service, "updateCpc", body )
          return process(response, 'cpcTypes', debug){|x| reverse_type(x)  }
        end

        def self.delete( auth, ids, debug = false )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcIds: ids}
          response = request( auth, Service, 'deleteCpc', body )
          return process(response, 'nil', debug){|x| x }
        end

        def self.search_by_group_id( auth, group_ids, debug = false  )
          """
          getKeywordByGroupIds
          @input: list of group id
          @output:  list of groupKeyword
          """
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { cpcGrpIds: group_ids }
          response = request( auth, Service, "getCpcByCpcGrpId", body )
          return process(response, 'cpcGrpCpcTypes', debug){|x| make_groupKeywords( x ) }
        end

        def self.search_id_by_group_id( auth, group_ids, debug = false  )
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { cpcGrpIds: group_ids }
          response = request( auth, Service, "getCpcIdeaByCpcGrpId", body )
          return process(response, 'cpcGrpCpcIdTypes', debug){|x| make_groupKeywordIds( x ) }
        end

        # sogou的keyword服务不提供质量度
        # def self.status( auth, ids, type, debug = false )
        #   ids = [ ids ] unless ids.is_a? Array
        #   body = { ids: ids, type: Type[type]}
        #   response = request( auth, Service, 'getKeywordStatus', body )
        #   return process(response, 'keywordStatus', debug){|x| reverse_type( x ) }
        # end

        # def self.quality( auth ,ids, type, device, debug = false )
        #   '''
        #   Return 10Quanlity *Not the old Quality* of given ketword id
        #   '''
        #   ids = [ ids ] unless ids.is_a? Array
        #   body = { ids: ids, type: Type[type], device:Device[device] }
        #   response = request( auth, Service, 'getKeyword10Quality', body )
        #   return process(response, 'keyword10Quality', debug){|x| reverse_type( x, @quality10_map ) }
        # end

        private
        def self.make_groupKeywordIds( cpcGrpCpcIdTypes )
          group_keyword_ids = []
          cpcGrpCpcIdTypes.each do |cpcGrpCpcIdType|
            group_keyword_id = { }
            group_keyword_id[:group_id] = cpcGrpCpcIdType[:cpc_grp_id]
            group_keyword_id[:keyword_ids] = cpcGrpCpcIdType[:cpc_ids]
            group_keyword_ids << group_keyword_id
          end
          return group_keyword_ids
        end

        private
        def self.make_groupKeywords( cpcGrpCpcTypes )
          group_keywords = []
          cpcGrpCpcTypes.each do |cpcGrpCpcType|
            group_keyword = {}
            group_keyword[:group_id] = cpcGrpCpcType[:cpc_grp_id]
            group_keyword[:keywords] = reverse_type( cpcGrpCpcTypes[:cpc_types] )
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
                  param[ key[0] ] = Match_type_r[ value ] if value                 
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