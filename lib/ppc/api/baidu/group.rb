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
          reserved:           :reserved,
          price_ratio:        :priceRatio,
          accu_price_factor:  :accuPriceFactor,
          word_price_factor:  :wordPriceFactor,
          wide_price_factor:  :widePriceFactor,
          match_price_status: :matchPriceStatus,
        }
        @map = GroupType

        def self.ids(auth )
          """
          @return : Array of campaignAdgroupIds
          """
          response = request( auth, Service , "getAllAdgroupId" )
          process( response, 'campaignAdgroupIds' ){ |x| make_planGroupIds( x ) }
        end

        def self.get( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids }
          response = request(auth, Service, "getAdgroupByAdgroupId",body )
          process( response, 'adgroupTypes' ){ |x| reverse_type(x) }
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

        def self.search_by_plan_id( auth, ids )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          response = request( auth, Service ,"getAdgroupByCampaignId",  body )
          process( response, 'campaignAdgroups' ){ |x| make_planGroups( x ) }
        end

        def self.search_id_by_plan_id( auth, ids )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          response = request( auth, Service ,"getAdgroupIdByCampaignId",  body )
          process( response, 'campaignAdgroupIds' ){ |x| make_planGroupIds( x ) }
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