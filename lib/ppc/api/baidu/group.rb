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
          ids = [ ids ] unless ids.is_a? Array
          body = {ids: ids, idType: 5, adgroupFields: GroupType.values}
          response = request(auth, Service, "getAdgroup",body )
          process( response, 'adgroupType' ){ |x| reverse_type( x )[0] }
        end

        def self.all( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = { ids: ids, idType: 3, adgroupFields: GroupType.values}
          response = request(auth,Service,'getAdgroup',body)
          return process( response, 'campaignAdgroups' ){ |x|reverse_type(x) }
        end

        def self.ids( auth, ids )
          """
          @return : Array of campaignAdgroupIds
          """
          ids = [ ids ] unless ids.is_a? Array
          body = {ids: ids, idType: 3, adgroupFields: [:adgroupId]}
          response = request(auth, Service, "getAdgroup",body )
          process( response, 'campaignAdgroupIds' ){ |x| reverse_type( x ) }
        end

        def self.get( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = {ids: ids, idType: 5, adgroupFields: GroupType.values}
          response = request(auth, Service, "getAdgroup",body )
          process( response, 'adgroupTypes' ){ |x| reverse_type( x ) }
        end

        def self.add( auth, groups )
          """
          @ input : one or list of AdgroupType
          @ output : list of AdgroupType
          """
          adgrouptypes = make_type( groups )

          body = {adgroupTypes:  adgrouptypes }
          
          response = request( auth, Service, "addAdgroup", body  )
          process( response, 'adgroupTypes' ){ |x| reverse_type(x) }
        end

        def self.update( auth, groups )
          """
          @ input : one or list of AdgroupType
          @ output : list of AdgroupType
          """
          adgrouptypes = make_type( groups )
          body = {adgroupTypes: adgrouptypes}
          
          response = request( auth, Service, "updateAdgroup",body )
          process( response, 'adgroupTypes' ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids )
          """
          delete group body has no message
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids }
          response = request( auth, Service,"deleteAdgroup", body )
          process( response, 'nil' ){ |x|  x  }
        end

        def self.enable( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          groups = ids.map{|id| {adgroupId: id, pause: false} }
          self.update( auth, groups )
        end

        def self.activate( auth, ids )
          self.enable( auth, ids )
        end

        def self.pause( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          groups = ids.map{|id| {keywordId: id, pause: true} }
          self.update( auth, groups )
        end

        private
        def self.make_planGroupIds( campaignAdgroupIds )
          planGroupIds = []
          campaignAdgroupIds.each do |campaignAdgroupId|
            planGroupId = { }
            planGroupId[:plan_id] = campaignAdgroupId['campaignId']
            planGroupId[:group_ids] = campaignAdgroupId['adgroupIds']
            planGroupIds << planGroupId
          end
          return planGroupIds
        end

        private
        def self.make_planGroups( campaignAdgroups )
          planGroups = []
          campaignAdgroups.each do |campaignAdgroup|
            planGroup = {}
            planGroup[:plan_id] = campaignAdgroup['campaignId']
            planGroup[:groups] = reverse_type( campaignAdgroup['adgroupTypes'] )
            planGroups << planGroup
          end
          return planGroups
        end

      end # class group
    end # class baidu
  end # API
end # module