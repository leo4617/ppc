module PPC
  module API
    class Baidu
      class Plan< Baidu
        Service = 'Campaign'

        @map = [
                          [:id,:campaignId],
                          [:name,:campaignName],
                          [:budget,:budget], 
                          [:region,:regionTarget],
                          [:ip,:excludeIp] ,
                          [:negative,:negativeWords],
                          [:exact_negative,:exactNegativeWords],
                          [:schedule,:schedule], 
                          [:budget_offline_time,:budgetOfflineTime],
                          [:show_prob,:showProb],   
                          [:device,:device],
                          [:price_ratio,:priceRatio], 
                          [:pause,:pause],
                          [:status,:status],
                        ]

        def self.all( auth, test = false )
          response = request( auth, Service, 'getAllCampaign' )
          process( response, 'campaignTypes' , test ){ |x| reverse_type(x) }
        end

        def self.ids( auth, test = false )
          response = request( auth, Service, 'getAllCampaignId' )
          process( response, 'campaignIds' , test ){ |x| x }
        end

        def self.get( auth, ids, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { campaignIds: ids }
          response = request( auth, Service, 'getCampaignByCampaignId', body)
          process( response, 'campaignTypes' , test ){ |x| reverse_type(x) }
        end

        def self.add( auth, plans, test = false )
          campaigntypes = make_type( plans )
          body = { campaignTypes: campaigntypes }
          response = request( auth, Service, 'addCampaign', body)
          process( response, 'campaignTypes' , test ){ |x| reverse_type(x) }
        end

        def self.update(auth,plans, test = false )
          campaigntypes = make_type( plans )
          body = { campaignTypes: campaigntypes }
          response = request( auth, Service, 'updateCampaign', body)
          process( response, 'campaignTypes' , test ){ |x| reverse_type(x) }
        end

        def self.delete(auth, ids, test = false )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          response = request( auth, 'Campaign', 'deleteCampaign', body)
          process( response, 'result' , test ){ |x| x }
        end


        # def self.make_campaigntype( plans )
        #   plans = [plans] unless plans.is_a? Array

        #   campaigntypes = []
        #   plans.each do |plan|
        #     campaigntype = {}
            
        #     campaigntype[:campaignId]                =   plan[:id]                                  if    plan[:id]  
        #     campaigntype[:campaignName]         =   plan[:name]                           if    plan[:name]
        #     campaigntype[:budget]                         =   plan[:budget]                        if    plan[:budget]
        #     campaigntype[:regionTarget]               =   plan[:region]                         if    plan[:region] 
        #     campaigntype[:excludeIp]                    =   plan[:ip]                                  if    plan[:ip]
        #     campaigntype[:negativeWords]           =   plan[:negative]                      if    plan[:negative]  
        #     campaigntype[:exactNegativeWords] =   plan[:exact_negative]           if    plan[:exact_negative]
        #     campaigntype[:schedule]                      =   plan[:schedule]                      if    plan[:schedule]
        #     campaigntype[:budgetOfflineTime]     =   plan[:budget_offline_time]  if    plan[:budget_offline_time]
        #     campaigntype[:showProb]                    =   plan[:show_prob]                  if    plan[:show_prob]
        #     campaigntype[:device]                           =   plan[:device]                          if    plan[:device] 
        #     campaigntype[:priceRatio]                    =   plan[:price_ratio]                   if    plan[:price_ratio]
        #     campaigntype[:pause]                            =   plan[:pause]                           if    plan[:pause]

        #     campaigntypes << campaigntype
        #   end
        #   return campaigntypes
        # end

        # private 
        # def reverse_campaigntype( types )
        #   types = [ types ] unless types.is_a Array
        #   plans = []

        #   types.each do |type|
        #     plan = {}
        #     plan[:id]                                  =    type['campaignId']                   if     type['campaignId']
        #     plan[:name]                           =     type['campaignName']           if     type['campaignName']
        #     plan[:budget]                         =    type['budget']                            if    type['budget'] 
        #     plan[:region]                          =    type['regionTarget']                  if    type['regionTarget']
        #     plan[:ip]                                  =     type['excludeIp']                      if    type['excludeIp'] 
        #     plan[:negative]                      =     type['negativeWords']             if    type['negativeWords']
        #     plan[:exact_negative]           =     type['exactNegativeWords']  if     type['exactNegativeWords']
        #     plan[:schedule]                      =    type['schedule']                        if    type['schedule'] 
        #     plan[:budget_offline_time]  =     type['budgetOfflineTime']     if    type['budgetOfflineTime']
        #     plan[:show_prob]                  =     type['showProb']                     if    type['showProb']   
        #     plan[:device]                           =     type['device']                           if    type['device']
        #     plan[:price_ratio]                    =    type['priceRatio']                     if    type['priceRatio'] 
        #     plan[:status]                            =    type['status']                            if    type['status']
        #     plans << plan
        #   end
        #   return plans
        # end
       
      end # Service
    end # baidu
  end # API
end # PPC