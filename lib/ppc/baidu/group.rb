module PPC
  class Baidu
    class Group < ::PPC::Baidu
      def initialize(params = {})
        params[:service] = 'Adgroup'
        super(params)
      end

      def all()
        """
        @return : Array of campaignAdgroupIds
        """
        request( "getAllAdgroupId" )["campaignAdgroupIds"]
      end

      def add( params = {})
        """
        @ input : one or list of AdgroupType
        @ output : list of AdgroupType
        """       
        params = [ params ] unless params.class == Array
        adgroupType = []
        
        params.each{  | group_i |
          adgroupType << make_adgroupType( group_i ) 
        }

        request( "addAdgroup", {adgroupTypes: adgroupType} )["adgroupTypes"]
      end

      def update( params = {} )
        """
        @ input : one or list of AdgroupType
        @ output : list of AdgroupType
        """
        params = [ params ] unless params.class == Array
        adgroupType = []
        
        params.each{  | group_i |
          adgroupType << make_adgroupType( group_i ) 
        }

        request( "updateAdgroup", {adgroupTypes: adgroupType} )["adgroupTypes"]
      end

      def delete( ids, return_header = false )
        """
        """
        ids = [ ids ] unless ids.class == Array
        # enable request to return header so that we can examine the test
        request("deleteAdgroup", { adgroupIds: ids } , return_header )          
      end

      def search_by_campaignID( ids, return_header = false )
        params = [ params ] unless params.class == Array
        request("getAdgroupByCampaignId", { campaignIds: ids } ,return_header )  
      end

      def search_by_groupID( ids, return_header = false )
        params = [ params ] unless params.class == Array
        request("getAdgroupByAdgroupId", { adgroupIds: ids } )
        request("getAdgroupByCampaignId", { campaignIds: ids } ,return_header )  

      end

      private 
        def make_adgroupType( params={} )
          adgrouptype = {
            campaignId:               params[:plan_id],
            adgroupId:              params[:group_id],
            adgroupName:              params[:name],
            maxPrice:              params[:maxprice],
            negativeWords:              params[:negative],
            exactNegativeWords:              params[:exact_negative],
            pause:              params[:pause],
            status:              params[:status],
            reserved:              params[:reserved]
          }
          # delete empty node
          adgrouptype.each{
            |pair|
            key, value = pair
            adgrouptype.delete(key) if value == nil
          }
          # delete invalid note according to request type
          # unimplemented
          return adgrouptype
        end #make_adgroupType

    end # class group
  end # class baidu 
end # module