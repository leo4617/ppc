# -*- coding:utf-8 -*-
"""
Todo: Implement Activate Method
"""
module PPC
  module API
    class Sogou
      class Keyword< Sogou
        Service = 'Cpc'

        #Match_type  = { 'exact' => 0, 'wide' => 1,0 => 'exact', 1 => 'wide' } 
        Match_type  = { 'exact' => 0, 'phrase' => 2, 'wide' => 1,'0' => 'exact', '2' => 'phrase', '1' => 'wide' } 
                
        KeywordType = {
          id:                 :cpcId,
          group_id:           :cpcGrpId,
          keyword:            :cpc,
          price:              :price,
          pc_destination:     :visitUrl,
          mobile_destination: :mobileVisitUrl,
          match_type:         :matchType,
          pause:              :pause,
          status:             :status,
          quality:            :cpcQuality,
        }
        @map = KeywordType

        @quality_map = {
          id:       :cpcId,
          quality:  :cpcQuality,
        }

        @status_map = {
          id:     :cpcId,
          status: :status,
        }

        # 后面改成info方法
        def self.get( auth, ids )
          '''
          getCpcByCpcId
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcIds: ids}
          response = request( auth, Service, 'getCpcByCpcId', body )
          process(response, 'cpcTypes'){|x| reverse_type( x ) }
        end

        def self.add( auth, keywords )
          '''
          '''
          cpcTypes = make_type( keywords ) 
          body = { cpcTypes: cpcTypes }
          response = request( auth, Service, "addCpc", body )
          process(response, 'cpcTypes'){|x| reverse_type(x)  }
        end

        def self.update( auth, keywords )
          '''
          '''
          cpcTypes = make_type( keywords ) 
          body = { cpcTypes: cpcTypes }
          response = request( auth, Service, "updateCpc", body )
          process(response, 'cpcTypes'){|x| reverse_type(x)  }
        end

        def self.delete( auth, ids )
          """
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcIds: ids}
          response = request( auth, Service, 'deleteCpc', body )
          process(response, ''){|x| x }
        end

        def self.search_by_group_id( auth, group_ids )
          """
          getKeywordByGroupIds
          @input: list of group id
          @output:  list of groupKeyword
          """
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { cpcGrpIds: group_ids }
          response = request( auth, Service, "getCpcByCpcGrpId", body )
          process(response, 'cpcGrpCpcs'){|x| make_groupKeywords( x ) }
        end

        def self.search_id_by_group_id( auth, group_ids )
          group_ids = [ group_ids ] unless group_ids.is_a? Array
          body = { cpcGrpIds: group_ids }
          response = request( auth, Service, "getCpcIdByCpcGrpId", body )
          process(response, 'cpcGrpCpcIds'){|x| make_groupKeywordIds( x ) }
        end

        # sogou的keyword服务不提供质量度和状态，从getInfo方法中查询
        def self.status( auth, ids )
          '''
          Return [ { id: id, status: status} ... ]
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcIds: ids}
          response = request( auth, Service, 'getCpcByCpcId', body )
          process(response, 'cpcTypes'){  |x|  reverse_type(x, @status_map) }
        end

        def self.quality( auth ,ids )
          '''
          Return [ { id: id, quality: quality} ... ]
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcIds: ids}
          response = request( auth, Service, 'getCpcByCpcId', { cpcIds: ids} )
          process(response, 'cpcTypes'){  |x| reverse_type(x, @quality_map) }
        end

        private
        def self.make_groupKeywordIds( cpcGrpCpcIdTypes )
          """
          Transfer Sogou API to PPC API
          """
          cpcGrpCpcIdTypes = [cpcGrpCpcIdTypes] unless cpcGrpCpcIdTypes.is_a? Array
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
          cpcGrpCpcTypes = [cpcGrpCpcTypes] unless cpcGrpCpcTypes.is_a? Array 
          group_keywords = []
          cpcGrpCpcTypes.each do |cpcGrpCpcType|
            group_keyword = {}
            group_keyword[:group_id] = cpcGrpCpcType[:cpc_grp_id]
            group_keyword[:keywords] = reverse_type( cpcGrpCpcType[:cpc_types] )
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
                  type[ key[1] ] = value if value != nil
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
                  value = type[ key[1].to_s.snake_case.to_sym]
                  param[ key[0] ] = Match_type[ value ] if value                 
                else
                  value = type[ key[1].to_s.snake_case.to_sym ]
                  param[ key[0] ] = value if value != nil
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
