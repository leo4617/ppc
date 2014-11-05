# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Plan < Qihu
        Service = 'campaign'

        @map = [
                        [:id, :id],
                        [:name,:name],
                        [:budget, :budget],
                        [:region, :region],
                        [:schedule, :schedule],
                        [:startDate, :startDate],
                        [:endDate, :endDate ],
                        [:status,:status], 
                        [:extend_ad_type,:extendAdType]
                      ]

        def self.get( auth, ids )
          '''
          :Type ids: ( Array of ) String or integer
          '''
          ids = to_json_string( ids )    
          body = { ' idList' =>  ids  }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'campaignList' ){ |x| reverse_type( x['item'] ) }
        end
        
        def self.add( auth, plan )
          response = request( auth, Service, 'add', make_type( plan )[0])
          process( response, 'id' ){ |x| x }
        end

        def self.update( auth, plan ) 
           response = request( auth, Service, 'update', make_type( plan )[0])
           process( response, 'id' ){ |x| x }
        end

        def self.delete( auth, id )
          response = request( auth, Service, 'deleteById', { id: id } )
          process( response, 'campaign_deleteById_response' ){ |x|  x }
        end

      end
    end
  end
end