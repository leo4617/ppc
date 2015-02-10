# -*- coding:utf-8 -*-
module PPC
  module API
    class Sogou
      class Creative< Sogou
        Service = 'CpcIdea'

        @map =[
                [:id,:cpcIdeaId],
                [:group_id,:cpcGrpId],
                [:title,:title],
                [:description1,:description1],
                [:description2,:description2],
                [:pc_destination,:visitUrl],
                [:pc_display,:showUrl],
                [:moile_destination,:mobileVisitUrl],
                [:mobile_display,:mobileShowUrl],
                [:pause,:pause],
                [:status,:status] 
              ]

        @status_map = [
                        [:id,:cpcIdeaId],
                        [:status,:status]
                      ]


        def self.add( auth, creatives )
          body = { cpcIdeaTypes: make_type( creatives ) }
          response = request( auth, Service, 'addCpcIdea', body )
          process( response, 'cpcIdeaTypes' ){ |x| reverse_type(x) }
        end

        def self.get( auth, ids,  getTemp = 0 )
          '''
          \'getCreativeByCreativeId\'
          @ input : creative ids
          @ output: creative informations
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcIdeaIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCpcIdeaByCpcIdeaId', body )
          process( response, 'cpcIdeaTypes' ){ |x| reverse_type(x) }
        end

        def self.update( auth, creatives )
          '''
          根据实际使用情况，更新的时候creative title为必填选
          '''
          body = { cpcIdeaTypes: make_type( creatives ) }
          response = request( auth, Service, 'updateCpcIdea', body )
          process( response, 'cpcIdeaTypes' ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcIdeaIds: ids }
          response = request( auth, Service, 'deleteCpcIdea', body )
          process( response, '' ){ |x| x }
        end

        def self.status( auth, ids, getTemp = 0 )
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcIdeaIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCpcIdeaByCpcIdeaId', body )
          process( response, 'cpcIdeaTypes' ){ |x| reverse_type(x, @status_map) }
        end

        def self.search_id_by_group_id( auth, ids,  getTemp = 0 )
          '''
          \'getCreativeIdByAdgroupId\'
          @ input: group ids
          @ output:  groupCreativeIds
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcGrpIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCpcIdeaIdByCpcGrpId', body )
          process( response, 'cpcGrpIdeaIds' ){ |x| make_groupCreativeIds( x ) }
        end

        def self.search_by_group_id( auth, ids,  getTemp = 0 )
          ids = [ ids ] unless ids.is_a? Array
          body = { cpcGrpIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCpcIdeaByCpcGrpId', body )
          process( response, 'cpcGrpIdeas' ){ |x| make_groupCreatives( x ) }
        end

        private
        def self.make_groupCreativeIds( cpcGrpIdeaIdTypes )
          cpcGrpIdeaIdTypes = [cpcGrpIdeaIdTypes] unless cpcGrpIdeaIdTypes.is_a? Array
          group_creative_ids = []
          cpcGrpIdeaIdTypes.each do |cpcGrpIdeaIdType|
            group_creative_id = { }
            group_creative_id[:group_id] = cpcGrpIdeaIdType[:cpc_grp_id]
            group_creative_id[:creative_ids] = cpcGrpIdeaIdType[:cpc_idea_ids]
            group_creative_ids << group_creative_id
          end
          return group_creative_ids
        end

        private
        def self.make_groupCreatives( cpcGrpIdeaTypes )
          cpcGrpIdeaTypes = [cpcGrpIdeaTypes] unless cpcGrpIdeaTypes.is_a? Array
          group_creatives = []
          cpcGrpIdeaTypes.each do |cpcGrpIdeaType|
            group_creative = {}
            group_creative[:group_id] = cpcGrpIdeaType[:cpc_grp_id]
            group_creative[:creatives] = reverse_type( cpcGrpIdeaType[:cpc_idea_types] )
            group_creatives << group_creative
          end
          return group_creatives
        end

      end
    end
  end
end
