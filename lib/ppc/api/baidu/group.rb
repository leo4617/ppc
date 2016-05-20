# -*- coding:utf-8  -*-
module PPC
  module API
    class Baidu
      class Group< Baidu
        Service = 'Adgroup'

        GroupType = {
          plan_id:            :campaignId,
          id:                 :adgroupId,
          name:               :adgroupName,
          price:              :maxPrice,
          negative:           :negativeWords,
          exact_negative:     :exactNegativeWords,
          pause:              :pause,
          status:             :status,
          price_ratio:        :priceRatio,
          accu_price_factor:  :accuPriceFactor,
          word_price_factor:  :wordPriceFactor,
          wide_price_factor:  :widePriceFactor,
          match_price_status: :matchPriceStatus,
        }
        @map = GroupType

        def self.info( auth, ids)
          body = {ids: ids, idType: 5, adgroupFields: GroupType.values}
          response = request(auth, Service, "getAdgroup",body )
          process( response, 'adgroupType' ){ |x| reverse_type( x )[0] }
        end

        def self.all( auth, plan_ids )
          body = { ids: plan_ids, idType: 3, adgroupFields: GroupType.values}
          response = request(auth, Service, 'getAdgroup', body)
          process( response, 'campaignAdgroups' ){ |x|reverse_type(x) }
        end

        def self.ids( auth, plan_ids )
          body = {ids: plan_ids, idType: 3, adgroupFields: [:adgroupId]}
          response = request(auth, Service, "getAdgroup",body )
          process( response, 'campaignAdgroupIds' ){ |x| reverse_type( x ) }
        end

        def self.get( auth, ids )
          body = {ids: ids, idType: 5, adgroupFields: GroupType.values}
          response = request(auth, Service, "getAdgroup",body )
          process( response, 'adgroupTypes' ){ |x| reverse_type( x ) }
        end

        def self.add( auth, groups )
          body = {adgroupTypes:  make_type( groups ) }
          response = request( auth, Service, "addAdgroup", body  )
          process( response, 'adgroupTypes' ){ |x| reverse_type(x) }
        end

        def self.update( auth, groups )
          body = {adgroupTypes: make_type( groups )}
          response = request( auth, Service, "updateAdgroup",body )
          process( response, 'adgroupTypes' ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids )
          body = { adgroupIds: ids }
          response = request( auth, Service,"deleteAdgroup", body )
          process( response, 'nil' ){ |x|  x  }
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