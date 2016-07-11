# -*- coding:utf-8 -*-
module PPC
  module API
    class Sogou
      class Creative< Sogou
        Service = 'CpcIdea'

        CreativeType = {
          id:                 :cpcIdeaId,
          group_id:           :cpcGrpId,
          title:              :title,
          description1:       :description1,
          description2:       :description2,
          pc_destination:     :visitUrl,
          pc_display:         :showUrl,
          moile_destination:  :mobileVisitUrl,
          mobile_display:     :mobileShowUrl,
          pause:              :pause,
          status:             :status,
          "group_id" =>       :cpc_grp_id,
          "id" =>             :cpc_idea_id,
          "pc_destination" => :visit_url,
          "pc_display" =>     :show_url,
          "mobile_display" => :mobile_show_url,
          "creative_ids" =>   :cpc_idea_ids,
        }
        @map = CreativeType

        @status_map = {
          id:      :cpcIdeaId,
          status:  :status,
        }

        def self.info( auth, ids,  getTemp = 0 )
          body = { cpcIdeaIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCpcIdeaByCpcIdeaId', body )
          process( response, 'cpcIdeaTypes' ){ |x| reverse_type(x)[0] }
        end

        def self.all( auth, ids,  getTemp = 0 )
          body = { cpcGrpIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCpcIdeaByCpcGrpId', body )
          process( response, 'cpcGrpIdeas' ){ |x| ids.count == 1 ? reverse_type(x[:cpc_idea_types]) : x.map{|y| reverse_type(y[:cpc_idea_types])}.flatten }
        end

        def self.ids( auth, ids,  getTemp = 0 )
          body = { cpcGrpIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCpcIdeaIdByCpcGrpId', body )
          process( response, 'cpcGrpIdeaIds' ){ |x| reverse_type( x ) }
        end

        def self.add( auth, creatives )
          body = { cpcIdeaTypes: make_type( creatives ) }
          response = request( auth, Service, 'addCpcIdea', body )
          process( response, 'cpcIdeaTypes' ){ |x| reverse_type(x) }
        end

        def self.get( auth, ids,  getTemp = 0 )
          body = { cpcIdeaIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCpcIdeaByCpcIdeaId', body )
          process( response, 'cpcIdeaTypes' ){ |x| reverse_type(x) }
        end

        def self.update( auth, creatives )
          body = { cpcIdeaTypes: make_type( creatives ) }
          response = request( auth, Service, 'updateCpcIdea', body )
          process( response, 'cpcIdeaTypes' ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids )
          response = request( auth, Service, 'deleteCpcIdea', { cpcIdeaIds: ids } )
          process( response, '' ){ |x| x }
        end

        def self.enable( auth, ids )
          keywords = ids.map{|id| {id: id, pause: false} }
          self.update( auth, keywords )
        end

        def self.pause( auth, ids )
          keywords = ids.map{|id| {id: id, pause: true} }
          self.update( auth, keywords )
        end

        def self.status( auth, ids, getTemp = 0 )
          body = { cpcIdeaIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCpcIdeaByCpcIdeaId', body )
          process( response, 'cpcIdeaTypes' ){ |x| reverse_type(x, @status_map) }
        end

      end
    end
  end
end
