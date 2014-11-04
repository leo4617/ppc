# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Plan < Qihu
        Service = 'campaign'

        @map = [
                        [:id, :id]
                        [:name,:name  ],
                        [:budget, :budget  ],
                        [:region, :region  ],
                        [:schedule, :schedule ],
                        [:startDate, :startDate ],
                        [:endDate, :endDate  ],
                        [:status,:status], 
                        [:extend_ad_type,:extendAdType],
                      ]

        def self.get( ids )
          '''
          :Type ids: ( Array of ) String or integer
          '''
          ids = [ids] unless ids.is_a? Array
          # change ids to string
          ids_str = []
          ids.each{ |x| ids_str <<  x.to_s }

          body = { ' idList' => JSON.generate( ids_str ) }
          response = request( auth, Service, 'getInfoByIdList', body )
          process( response, 'campaign_getInfoById_response' ){ |x| reverse_type( x['campaignList']['item'] }
        end
        
        def self.add( plan )
          response = request( auth, Service, 'add', make_type( plan )[0])
          process( response, 'campaign_add_response' ){ |x| x['id'] }
        end

        def self.update( plan ) 
           response = request( auth, Service, 'update', make_type( plan )[0])
           process( response, 'campaign_update_response' ){ |x| x['id'] }
        end

        def self.delete( id )
          response = request( auth, Service, 'deleteById', id )
          process( response, 'campaign_deleteById_response' ){ |x|  x }
        end
      end
    end
  end
end