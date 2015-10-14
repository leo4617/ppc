module PPC
  module API
    class Qihu
      class Rank < Qihu
        Service = 'tool'

        @map = [
                 [:id,:id] ,
                 [:group_id, :groupId],
                 [:anchor,:text],
                 [:url, :link],
                 [:image, :image],
                 [:status, :status]
                ]

        def self.getRank( auth, region, queryInfo )
          body  = {'region'=> region, 'queryInfo' => queryInfo}
          response = request(auth, Service, 'realTimeQueryResult', body)
          # process( response, 'sublinkList'){ |x| reverse_type( x['item'] ) }
        end

      end
    end
  end
end