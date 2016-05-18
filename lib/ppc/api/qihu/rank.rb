module PPC
  module API
    class Qihu
      class Rank < Qihu
        Service = 'tool'

        RankType = {
          id:       :id,
          group_id: :groupId,
          anchor:   :text,
          url:      :link,
          image:    :image,
          status:   :status,
        }
        @map = RankType

        def self.getRank( auth, region, queryInfo )
          body  = {'region'=> region, 'queryInfo' => queryInfo}
          request(auth, Service, 'realTimeQueryResult', body)
        end

      end
    end
  end
end