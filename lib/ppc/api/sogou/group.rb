# -*- coding:utf-8  -*-
module PPC
  module API
    class Sogou
      class Group< Sogou
        Service = 'CpcGrp'

        GroupType = {
          plan_id:        :cpcPlanId,
          id:             :cpcGrpId,
          name:           :cpcGrpName,
          price:          :maxPrice,
          negative:       :negativeWords,
          exact_negative: :exactNegativeWords,
          pause:          :pause,
          status:         :status,
          opt:            :opt,
          "plan_id" =>    :cpc_plan_id,
          "id" =>         :cpc_grp_id,
          "plan_name" =>  :cpc_plan_name,
          "name" =>       :cpc_grp_name,
          "price" =>      :max_price,
        }
        @map = GroupType

        def self.info( auth, ids)
          response = request(auth, Service, "getCpcGrpByCpcGrpId", {cpcGrpIds: ids} )
          process( response, 'cpc_grp_types' ){ |x| reverse_type(x)[0] }
        end

        def self.all( auth, plan_ids )
          response = request( auth, Service ,"getCpcGrpByCpcPlanId",  {cpcPlanIds: plan_ids} )
          process( response, 'cpc_plan_grps' ){ |x| reverse_type( x[:cpc_grp_types] ) }
        end

        def self.ids( auth, plan_ids )
          response = request( auth, Service ,"getCpcGrpIdByCpcPlanId",  {cpcPlanIds: plan_ids} )
          process( response, 'cpcPlanGrpIds' ){ |x| reverse_type( x ) }
        end

        def self.get( auth, ids )
          response = request(auth, Service, "getCpcGrpByCpcGrpId", {cpcGrpIds: ids} )
          process( response, 'cpc_grp_types' ){ |x| reverse_type(x) }
        end

        def self.add( auth, groups )
          body = {cpcGrpTypes: make_type( groups ) }
          response = request( auth, Service, "addCpcGrp", body  )
          process( response, 'cpc_grp_types' ){ |x| reverse_type(x) }
        end

        def self.update( auth, groups )
          body = {cpcGrpTypes: make_type( groups )}
          response = request( auth, Service, "updateCpcGrp",body )
          process( response, 'cpc_grp_types' ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids )
          response = request( auth, Service,"deleteCpcGrp", {cpcGrpIds: ids} )
          process( response, '' ){ |x| x }
        end

        def self.enable( auth, ids )
          groups = ids.map{|id| {id: id, pause: false} }
          self.update( auth, groups )
        end

        def self.pause( auth, ids )
          groups = ids.map{|id| {id: id, pause: true} }
          self.update( auth, groups )
        end

      end # class group
    end # class baidu
  end # API
end # module
