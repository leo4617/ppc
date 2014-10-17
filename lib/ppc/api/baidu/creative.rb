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

        def self.add( auth, creatives, test = false )
          body = { creativeTypes: make_type( creatives ) }
          response = request( auth, Service, 'addCreative', body )
          process( response, 'creativeTypes', test ){ |x| reverse_type(x) }
        end

        def self.get( auth, ids,  getTemp = 0, test = false  )
          '''
          \'getCreativeByCreativeId\'
          @ input : creative ids
          @ output: creative informations
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { creativeIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCreativeByCreativeId', body )
          process( response, 'creativeTypes', test ){ |x| reverse_type(x) }
        end

        def self.update( auth, creatives, test = false )
          '''
          根据实际使用情况，更新的时候creative title为必填选
          '''
          body = { creativeTypes: make_type( creatives ) }
          response = request( auth, Service, 'addCreative', body )
          process( response, 'creativeTypes', test ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { creativeIds: ids }
          response = request( auth, Service, 'deleteCreative', body )
          process( response, 'result', test ){ |x| x }
        end

        def self.activate( auth, ids, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { creativeIds: ids }
          response = request( auth, Service, 'activateCreative', body )
          process( response, 'creativeTypes', test ){ |x| reverse_type(x) }
        end

        def self.status( auth, ids, type, test = false )
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
          process( response, 'CreativeStatus', test ){ |x| x }
        end

        def self.get_by_group_id( auth, ids,  getTemp = 0, test = false )
          '''
          \'getCreativeIdByAdgroupId\'
          @ input: group ids
          @ output:  groupCreativeIds
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCreativeIdByAdgroupId', body )
          process( response, 'groupCreativeIds', test ){ |x| x }
        end

        def self.search_by_group_id( auth, ids,  getTemp = 0, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getCreativeByAdgroupId', body )
          process( response, 'groupCreatives', test ){ |x| x }
        end

        # private 
        # def self.make_creativetype( params )
        #   params = [ params ] unless params.is_a? Array
        #   creativetypes = []
        #   params.each{  |param| 
        #     creativetype = {}
        #     creativetype[:creativeId]                       =    param[:id]                                 if    param[:id] 
        #     creativetype[:adgroupId]                      =     param[:group_id]                    if     param[:group_id] 
        #     creativetype[:title]                                  =     param[:title]                            if     param[:title]  
        #     creativetype[:description1]                   =     param[:description1]            if     param[:description1]  
        #     creativetype[:description2]                   =     param[:description2]            if     param[:description2]
        #     creativetype[:pcDestinationUrl]           =     param[:pc_destination]         if     param[:pc_destination] 
        #     creativetype[:pcDisplayUrl]                   =     param[:pc_display]                if     param[:pc_display]   
        #     creativetype[:mobileDestinationUrl]   =     param[:moile_destination]   if     param[:moile_destination]
        #     creativetype[:mobileDisplayUrl]           =     param[:mobile_display]        if     param[:mobile_display]  
        #     creativetype[:pause]                               =     param[:pause]                        if     param[:pause]    
        #     creativetype[:devicePreference]           =     param[:preference]              if     param[:preference] 
            
        #     creativetypes << creativetype
        #   }
        #   return creativetypes
        # end

      end
    end
  end
end
