# -*- coding:utf-8 -*-
module PPC
  module API
    module Baidu
      module Creative
        include ::PPC::API::Baidu
        Service = 'Creative'

        def self.add( auth, creatives )
          creatives = [ creatives ] unless creatives.is_a? Array
          body = { creativeTypes: make_creativetype( creatives ) }
          request( auth, Service, 'addCreative', body )['creativeTypes']
        end

        def self.update( auth, creatives )
          '''
          考虑到实际使用情况，update这里的输入里面的symnol
          很可能是按照api的格式来的……看看再说吧
          '''
          creatives = [ creatives ] unless creatives.is_a? Array
          body = { creativeTypes: make_creativetype( creatives ) }
          request( auth, Service, 'updateCreative', body )['creativeTypes']
        end

        def self.delete( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = { creativeIds: ids }
          request( auth, Service, 'deleteCreative', body )['result']
        end

        def self.activate( auth, ids )
          ids = [ ids ] unless ids.is_a? Array
          body = { creativeIds: ids }
          request( auth, Service, 'activateCreative', body )['creativeTypes']
        end

        def self.status( auth, ids, type  )
          ids = [ ids ] unless ids.is_a? Array
          
          type = case type
            when  'plan'      then    3 
            when  'group'   then     5
            when  'key'       then     11
            else
              Exception.new( 'type must among: \'plan\',\'group\' and \'key\' ')            
          end

          body = { ids: ids, type: type }
          request( auth, Service, 'getCreativeStatus', body )['CreativeStatus']
        end

        def self.search_id_by_group_id( auth, ids,  getTemp = 0 )
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids, getTemp: getTemp }
          request( auth, Service, 'getCreativeIdByAdgroupId', body )['groupCreativeIds']
        end

        def self.search_by_group_id( auth, ids,  getTemp = 0 )
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids, getTemp: getTemp }
          request( auth, Service, 'getCreativeByAdgroupId', body )['groupCreatives']
        end

        def self.search_by_creative_id( auth, ids,  getTemp = 0 )
          ids = [ ids ] unless ids.is_a? Array
          body = { creativeIds: ids, getTemp: getTemp }
          request( auth, Service, 'getCreativeByCreativeId', body )['creativeTypes']
        end

        private 
        def make_creativetype( params )
          params = [ params ] unless params.is_a? Array
          creativetypes = []
          params.each{  |param| 
            creativetype = {}
            creativetype[:creativeId]                       =    param[:id]                                 if    param[:id] 
            creativetype[:adgroupId]                      =     param[:group_id]                    if     param[:group_id] 
            creativetype[:Title]                                  =     param[:title]                            if     param[:title]  
            creativetype[:description1]                   =     param[:description1]            if     param[:description1]  
            creativetype[:description2]                   =     param[:description2]            if     param[:description2]
            creativetype[:pcDestinationUrl]           =     param[:pc_destination]         if     param[:pc_destination] 
            creativetype[:pcDisplayUrl]                   =     param[:pc_display]                if     param[:pc_display]   
            creativetype[:mobileDestinationUrl]   =     param[:moile_destination]   if     param[:moile_destination]
            creativetype[:mobileDisplayUrl]           =     param[:mobile_display]        if     param[:mobile_display]  
            creativetype[:pause]                               =     param[:pause]                        if     param[:pause]    
            creativetype[:devicePreference]           =     param[:preference]              if     param[:preference] 
            
            creativetypes << creativetype
          }
          return creativetypes
        end

      end
    end
  end
end
