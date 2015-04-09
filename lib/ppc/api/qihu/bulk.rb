# -*- coding:utf-8 -*-
require 'json'
module PPC
  module API
    class Qihu
      class Bulk < Qihu
        Service = 'account'

        def self.get_all_object( auth, ids )
          #文档上面写的输入类型是String？
          body = {}
          body = { 'idList' =>  to_json_string(ids) } if ids
          response = request( auth, Service, 'getAllObjects', body )
          process( response, 'fileId' ){ |x| x }
        end

        def self.get_file_state( auth, id )
          body = { 'fileId' => id }
          response = request( auth, Service, 'getFileState' , body )
          process( response, '' ){ |x| x }
        end

        def self.download( auth, ids = nil)
          result = get_all_object(auth, ids)
          field_id = result[:result]
          loop do 
            status = get_file_state(auth, field_id)
            return status if status[:result]['isGenerated'] == 'success'
            sleep 15
          end
        end
      end
    end
  end
end
