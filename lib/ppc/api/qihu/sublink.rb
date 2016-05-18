# -*- coding:utf-8 -*-
module PPC
  module API
    class Qihu
      class Sublink< Qihu
        Service = 'sublink'

        SublinkType = {
          id:       :id,
          group_id: :groupId,
          anchor:   :text,
          url:      :link,
          image:    :image,
          pause:    :status,
        }
        @map = SublinkType

        def self.info( auth, ids )
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'sublinkList'){ |x| reverse_type( x['item'] )[0] }
        end

        def self.all( auth, id )
          sublink_ids = self.ids( auth, id )[:result][0][:sublink_ids]
          response = self.get( auth , sublink_ids )
          response[:result] = [ { group_id: id, sublinks: response[:result ] } ] if response[:succ]
          response
        end

        def self.ids( auth, id )
          response = request( auth, Service, 'getIdListByGroupId', {"groupId" => id[0]} )
          process( response, 'sublinkIdListList' ){ |x| { group_id: id, sublink_ids: x.map(&:to_i) } }
        end

        def self.get( auth, ids )
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'sublinkList'){ |x| reverse_type( x['item'] ) }
        end

        def self.add( auth, sublinks )
          response = request( auth, Service, 'add', { sublinks: make_type( sublinks ) } )
          process( response, 'sublinkIdList'){ |x| x['item'].map(&:to_i) }
        end

        def self.delete( auth, ids )
          response = request( auth, Service, 'deleteByIdList', { idList: ids } )
          process( response, 'affectedRecords' ){ |x|x }     
        end

        def self.update( auth, sublinks )
          response = request( auth, Service, 'update', { sublinks: make_type( sublinks ) } )
          process( response, 'affectedRecords', 'failKeywordIds' ){ |x| x }        
        end

        def self.delete( auth, ids )
          response = request( auth, Service, 'deleteByIdList', { idList: ids } )
          process( response, 'affectedRecords' ){ |x|x }     
        end

        def self.enable( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, pause: 'enable'} } )
        end

        def self.pause( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, pause: 'pause'} } )
        end

      end
    end
  end
end
