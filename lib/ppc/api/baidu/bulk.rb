module PPC
  module API
    module Baidu
      module Bulk
        include ::PPC::API::Baidu
        Service = 'BulkJob'

        def self.get_all_object( auth,params = {})
          
          plan_ids = params[:plan_ids]

          unless plan_ids.nil?
            plan_ids = plan_ids.class == Array ? plan_ids : [plan_ids]
          end

          options = {
            campaignIds:              plan_ids              || []      ,
            includeQuality:           params[:quality]      || true    ,
            includeTemp:              params[:temp]         || false   ,
            format:                   params[:format]       || 1       ,
            newCreativeFiles:         params[:adcopy]       || 0       ,
            includeTempNewCreatives:  params[:temp_adcopy]  || 0       ,
            includePhraseType:        params[:phrase]       || 0       ,
            extended:                 params[:extended]     || 0
          }
          response = request( auth, Service, 'getAllObjects',options )
          response[:get_all_objects_response][:file_id]
        end

        def self.state( auth, id)
          raise "empty id" if id.nil? or id.empty?
          request(auth, Service, 'getFileState',{fileId:id})[:get_file_state_response][:is_generated]
        end

        def self.path( auth, id)
          request( auth, Service, 'getFilePath',{fileId:id})[:get_file_path_response][:file_paths]
        end

      end
    end
  end
end
