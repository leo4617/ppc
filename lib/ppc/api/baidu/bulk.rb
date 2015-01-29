module PPC
  module API
    class Baidu
      class Bulk < Baidu
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
          process( response, 'fileId'){ |x| x }
        end

        def self.state( auth, id)
          raise "empty id" if id.nil? or id.empty?
          response = request(auth, Service, 'getFileState',{fileId:id})
          process( response, 'isGenerated'){ |x| x }
        end

        def self.path( auth, id)
          response = request( auth, Service, 'getFilePath',{fileId:id})
          process( response, 'filePaths' ){ |x| x }       
        end

        ###########################
        # interface for operation #
        ###########################
        def self.download( auth, params = {} )
          """
          """
          params[:extended] = params[:extended] || 2
          begin
            file_id = get_all_object( auth, params )
            if file_id[:succ]
              file_id = file_id[:result]
            else
              raise file_id[:failure][0]['message']
            end

            puts "file_id: #{file_id}" if @@debug

            loop do
              state = state( auth, file_id )[:result].to_s
              raise "invalid file state: #{state}" unless %w(1 2 3 null).include? state
              break if state == '3'
              puts "waiting for #{file_id} to be ready. current state:#{state}" if @@debug
              sleep 3
            end

            puts "#{file_id} is ready" if @@debug
            return path( auth, file_id )

          rescue => e
            p "Error encounter:#{e.to_s}"
          end  
          return false
        end

      end
    end
  end
end
