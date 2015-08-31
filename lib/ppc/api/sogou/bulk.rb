# -*- coding:utf-8 -*-
module PPC
  module API
    class Sogou
      class Bulk < Sogou
        Service = 'AccountDownload'

        def self.get_all_object( auth, ids )
          #文档上面写的输入类型是String？
          body = nil
          body = { 'cpcPlanIds' => ids } if ids
          response = request( auth, Service, 'getAccountFile', body )
          process( response, 'accountFileId' ){ |x| x }
        end

        def self.get_file_state( auth, id )
          body = { 'accountFileId' => id }
          response = request( auth, Service, 'getAccountFileStatus' , body )
          process( response, 'isGenerated' ){ |x| x }
        end

        def self.get_file_path(auth, id)
          body = {'accountFileId' => id}
          response = request(auth, Service, 'getAccountFilePath', body)
          process(response, 'accountFilePath'){|x| x}
        end

        def self.download( auth, ids = nil)
          result = get_all_object(auth, ids)
          field_id = result[:result]
          loop do 
            status = get_file_state(auth, field_id)
            return get_file_path(auth, field_id) if status[:result] == '1'
            sleep 15
          end
        end
      end
    end
  end
end
