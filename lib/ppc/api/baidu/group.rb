module PPC
  module API
    module Baidu
      module Group
        include ::PPC::API::Baidu
        Service = 'Adgroup'

        def self.all(auth)
          """
          @return : Array of campaignAdgroupIds
          """
          request( auth, Service , "getAllAdgroupId" )["campaignAdgroupIds"]
        end

        def self.add( auth, groups )
          """
          @ input : one or list of AdgroupType
          @ output : list of AdgroupType
          """
          groups = [ groups ] unless groups.is_a? Array
          adgroupType = []

          groups.each{  | group_i |
            adgroupType << make_adgrouptype( group_i )
          }

          body = {adgroupTypes: adgroupType}
          
          request( auth, Service, "addAdgroup", body  )['adgroupTypes'] 
        end

        def self.update( auth, groups )
          """
          @ input : one or list of AdgroupType
          @ output : list of AdgroupType
          """
          groups = [ groups ] unless groups.is_a?Array
          adgroupType = []

          groups.each{  | group_i |
            adgroupType << make_adgrouptype( group_i )
          }

          body = {adgroupTypes: adgroupType}
          
          request( auth, Service, "updateAdgroup" )['adgroupTypes']
        end

        def self.delete( auth, ids )
          """
          目前没办法返回header
          """
          ids = [ ids ] unless ids.is_a ? Array
          body = { adgroupIds: ids }
          request( auth, Service,"deleteAdgroup", body )[ 'header' ][ 'desc' ]
        end

        def self.search_by_planid( auth, ids )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          request( auth, Service ,"getAdgroupByCampaignId",  body )["campaignAdgroups"]
        end

        def self.search_by_groupid( auth, ids, test = false )
          ids = [ ids ] unless ids.class == Array
          body = { adgroupIds: ids }
          responses = request(auth, Service, "getAdgroupByAdgroupId",body )["adgroupTypes"]
        end

        private
          def make_adgrouptype( params )
            params = [ params ] unless params.is_a ? Array
            adgrouptypes = []
            params.each{  | param | 
              adgrouptype = {}

              adgrouptype[:campaignId]                  =   param[:plan_id]                 if    param[:plan_id] 
              adgrouptype[:adgroupId]                    =   param[:group_id]               if    param[:group_id] 
              adgrouptype[:adgroupName]             =   param[:name]                    if    param[:name] 
              adgrouptype[:maxPrice]                      =   param[:price]                     if    param[:price] 
              adgrouptype[:negativeWords]            =   param[:negative]               if    param[:negative]
              adgrouptype[:exactNegativeWords]  =   param[:exact_negative]    if    param[:exact_negative] 
              adgrouptype[:pause]                            =   param[:pause]                    if    param[:pause] 
              adgrouptype[:status]                            =   param[:status]                    if    param[:status] 
              adgrouptype[:reserved]                       =   param[:reserved]               if    param[:reserved] 
              
              adgrouptypes << adgrouptype
            }
            return adgrouptypes
          end #make_adgrouptype

      end # class group
    end # class baidu
  end # API
end # module