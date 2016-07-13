# -*- coding:utf-8 -*-
"""
Todo: Implement Activate Method
"""
module PPC
  module API
    class Sogou
      class Keyword< Sogou
        Service = 'Cpc'

        Match_type  = { 'exact' => 0, 'phrase' => 2, 'wide' => 1,'0' => 'exact', '2' => 'phrase', '1' => 'wide' }
        @match_types = Match_type
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
          "group_id" =>       :cpc_grp_id,
          "keyword_ids" =>    :cpc_ids,
          "keywords" =>       :cpc_types,
          "id" =>             :cpc_id,
          "pc_destination" => :visit_url,
          "quality" =>        :cpc_quality,
          "mobile_destination" => :mobile_visit_url,
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

        def self.info( auth, ids )
          response = request( auth, Service, 'getCpcByCpcId', {cpcIds: ids} )
          process(response, 'cpcTypes'){|x| reverse_type( x )[0] }
        end

        def self.all( auth, ids )
          response = request( auth, Service, "getCpcByCpcGrpId", {cpcGrpIds: ids} )
          process(response, 'cpcGrpCpcs'){|x| ids.count == 1 ? reverse_type(x[:cpc_types]) : x.map{|y| reverse_type(y[:cpc_types])}.flatten }
        end

        def self.ids( auth, ids )
          response = request( auth, Service, "getCpcIdByCpcGrpId", {cpcGrpIds: ids} )
          process(response, 'cpcGrpCpcIds'){|x| reverse_type( x ) }
        end

        def self.get( auth, ids )
          response = request( auth, Service, 'getCpcByCpcId', {cpcIds: ids} )
          process(response, 'cpcTypes'){|x| reverse_type( x ) }
        end

        def self.add( auth, keywords )
          body = { cpcTypes: make_type( keywords )  }
          response = request( auth, Service, "addCpc", body )
          process(response, 'cpcTypes'){|x| reverse_type(x)  }
        end

        def self.update( auth, keywords )
          body = { cpcTypes: make_type( keywords )  }
          response = request( auth, Service, "updateCpc", body )
          process(response, 'cpcTypes'){|x| reverse_type(x)  }
        end

        def self.delete( auth, ids )
          response = request( auth, Service, 'deleteCpc', {cpcIds: ids} )
          process(response, ''){|x| x }
        end

        def self.enable( auth, ids )
          keywords = ids.map{|id| {id: id, pause: false} }
          self.update( auth, keywords )
        end

        def self.pause( auth, ids )
          keywords = ids.map{|id| {id: id, pause: true} }
          self.update( auth, keywords )
        end

        # sogou的keyword服务不提供质量度和状态，从getInfo方法中查询
        def self.status( auth, ids )
          response = request( auth, Service, 'getCpcByCpcId', {cpcIds: ids} )
          process(response, 'cpcTypes'){|x|  reverse_type(x, @status_map) }
        end

        def self.quality( auth ,ids )
          response = request( auth, Service, 'getCpcByCpcId', {cpcIds: ids} )
          process(response, 'cpcTypes'){|x| reverse_type(x, @quality_map) }
        end

      end # keyword
    end # Baidu
  end # API
end # PPC
