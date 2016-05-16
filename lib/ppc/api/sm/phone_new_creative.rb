# -*- coding:utf-8 -*-
module PPC
  module API
    class Sm
      class Phone < Sm
        Service = 'NewCreative'

        PhoneType = {
          id:         :phoneId,
          group_id:   :adgroupId,
          phone_num:  :phoneNum,
          pause:      :pause,
        }
        @map = PhoneType
               
        def self.update( auth, phones )
          '''
          根据实际使用情况，更新的时候creative title为必填选
          '''
          body = { phoneTypes: make_type( phones ) }
          response = request( auth, Service, 'updatePhone', body )
          process( response, 'phoneTypes' ){ |x| reverse_type(x) }
        end

        def self.ids( auth, ids, getTemp = 0 )
          '''
          \'getPhoneIdByAdgroupId\'
          @ input: group ids
          @ output:  groupPhoneIds
          '''
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids, getTemp: getTemp }
          response = request( auth, Service, 'getPhoneIdByAdgroupId', body )
          process( response, 'groupPhoneIds' ){ |x| make_groupPhoneIds( x ) }
        end

        private
        def self.make_groupPhoneIds( groupPhoneIds )
          group_phone_ids = []
          groupPhoneIds.each do |phone_id|
            group_phone_id = { }
            group_phone_id[:group_id] = phone_id['adgroupId']
            group_phone_id[:phone_ids] = phone_id['phoneIds']
            group_phone_ids << group_phone_id
          end
          return group_phone_ids
        end

      end
    end
  end
end
