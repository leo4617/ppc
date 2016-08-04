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
          pause:    :sysStatus,
          status:   :status,
          add_time: :addTime,
          update_time: :updateTime,
          cause:    :cause,
        }
        @map = SublinkType

        def self.info( auth, ids )
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'sublinkList'){ |x| reverse_type( x )[0] }
        end

        def self.all( auth, group_ids )
          results = self.ids( auth, group_ids )
          return results unless results[:succ]
          self.get( auth , results[:result] )
        end

        def self.ids( auth, group_ids )
          response = request( auth, Service, 'getIdListByGroupIdList', {groupIdList: group_ids} )
          process( response, 'sublinkIdListList' ){ |x| x.map(&:to_i) }
        end

        def self.get( auth, ids )
          response = request( auth, Service, 'getInfoByIdList', { idList: ids } )
          process( response, 'sublinkList'){ |x| reverse_type( x ) }
        end

        def self.add( auth, sublinks )
          response = request( auth, Service, 'add', { sublinks: make_type( sublinks ) } )
          process( response, 'sublinkIdList'){ |x| x.map{|id| {id: id} } }
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
          self.update( auth, ids.map{ |id| { id: id, status: 'enable'} } )
        end

        def self.pause( auth, ids )
          self.update( auth, ids.map{ |id| { id: id, status: 'pause'} } )
        end

      end
    end
  end
end
