# -*- coding:utf-8 -*-
module PPC
  module API
    class Baidu
      class Creative< Baidu
        Service = 'Creative'

        @map =[
                        [:id,:creativeId],
                        [:group_id,:adgroupId],
                        [:title,:title],
                        [:description1,:description1],
                        [:description2,:description2],
                        [:pc_destination,:pcDestinationUrl],
                        [:pc_display,:pcDisplayUrl],
                        [:moile_destination,:mobileDestinationUrl],
                        [:mobile_display,:mobileDisplayUrl],
                        [:pause,:pause],
                        [:preference,:devicePreference] 
                      ]

        def self.add( auth, creatives, debug = false )
          body = { creativeTypes: make_type( creatives ) }
          response = request( auth, Service, 'addCreative', body )
          process( response, 'creativeTypes', debug ){ |x| reverse_type(x) }
        end

        def self.get( auth, ids,  getTemp = 0, debug = false  )
          '''
          \'getCreativeByCreativeId\'
          @ input : creative ids
          @ output: creative informations
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { creativeIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCreativeByCreativeId', body )
          process( response, 'creativeTypes', debug ){ |x| reverse_type(x) }
        end

        def self.update( auth, creatives, debug = false )
          '''
          根据实际使用情况
          '''
          body = { creativeTypes: make_type( creatives ) }
          response = request( auth, Service, 'updateCreative', body )
          process( response, 'creativeTypes', debug ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids, debug = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { creativeIds: ids }
          response = request( auth, Service, 'deleteCreative', body )
          process( response, 'result', debug ){ |x| x }
        end

        def self.activate( auth, ids, debug = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { creativeIds: ids }
          response = request( auth, Service, 'activateCreative', body )
          process( response, 'creativeTypes', debug ){ |x| reverse_type(x) }
        end

        def self.status( auth, ids, type, debug = false )
          ids = [ ids ] unless ids.is_a? Array
          
          type = case type
            when  'plan'      then    3 
            when  'group'   then     5
            when  'creative'       then     7
            else
              Exception.new( 'type must among: \'plan\',\'group\' and \'key\' ')            
          end

          body = { ids: ids, type: type }
          response = request( auth, Service, 'getCreativeStatus', body )
          process( response, 'CreativeStatus', debug ){ |x| x }
        end

        def self.search_id_by_group_id( auth, ids,  getTemp = 0, debug = false )
          '''
          \'getCreativeIdByAdgroupId\'
          @ input: group ids
          @ output:  groupCreativeIds
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCreativeIdByAdgroupId', body )
          process( response, 'groupCreativeIds', debug ){ |x| make_groupCreativeIds( x ) }
        end

        def self.search_by_group_id( auth, ids,  getTemp = 0, debug = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCreativeByAdgroupId', body )
          process( response, 'groupCreatives', debug ){ |x| make_groupCreatives( x ) }
        end

        private
        def self.make_groupCreativeIds( groupCreativeIds )
          group_creative_ids = []
          groupCreativeIds.each do |groupCreativeId|
            group_creative_id = { }
            group_creative_id[:group_id] = groupCreativeId['adgroupIds']
            group_creative_id[:creative_ids] = groupCreativeId['creativeIds']
            group_creative_ids << group_creative_id
          end
          return group_creative_ids
        end

        private
        def self.make_groupCreatives( groupCreatives )
          group_creatives = []
          groupCreatives.each do |groupCreative |
            group_creative = {}
            group_creative[:group_id] = groupCreative['adgroupId']
            group_creative[:creatives] = reverse_type( groupCreative['creativeTypes'] )
            group_creatives << group_creative
          end
          return group_creatives
        end

      end
    end
  end
end
