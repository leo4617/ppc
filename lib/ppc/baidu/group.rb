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

      def add( params={}, test = false)
        """
        @ input : one or list of AdgroupType
        @ output : list of AdgroupType
        """       
        params = [ params ] unless params.class == Array
        adgroupType = []
        
        params.each{  | group_i |
          adgroupType << make_adgrouptype( group_i ) 
        }

        body = {adgroupTypes: adgroupType}
        response = request( "addAdgroup", body, test )
        return response['adgroupTypes'] unless test else response
      end

      def update( params={}, test = false )
        """
        @ input : one or list of AdgroupType
        @ output : list of AdgroupType
        """
        params = [ params ] unless params.class == Array
        adgroupType = []
        
        params.each{  | group_i |
          adgroupType << make_adgrouptype( group_i ) 
        }

        body = {adgroupTypes: adgroupType}
        responses = request( "updateAdgroup", body, test )
        return responses['adgroupTypes'] unless test else responses
      end

      def delete( ids )
        # delete responses have no content therefore we 
        #return header.desc to judge whether operation success
        ids = [ ids ] unless ids.class == Array
        
        body = { adgroupIds: ids }
        request( "deleteAdgroup", body, true )[ 'header' ][ 'desc' ]
      end

      def search_by_planid( ids, test = false )
        ids = [ ids ] unless ids.class == Array
        body = { campaignIds: ids }
        responses = request("getAdgroupByCampaignId",  body, test )
        return responses["campaignAdgroups"]  unless test else responses
      end

      def search_by_groupid( ids, test = false )
        ids = [ ids ] unless ids.class == Array
        body = { adgroupIds: ids }
        responses = request("getAdgroupByAdgroupId",body, test )
        return responses["adgroupTypes"]  unless test else responses
      end

      private 
        def make_adgrouptype( params={} )
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
        end #make_adgrouptype

    end # class group
  end # class baidu 
end # module