module PPC
  module API
    class Sm
      class Bulk < Sm
        Service = 'bulkJob'

        def self.get_all_object( auth,params = {})
          
          plan_ids = params[:plan_ids]

          unless plan_ids.nil?
            plan_ids = plan_ids.class == Array ? plan_ids : [plan_ids]
          end

          options = {
            bulkJobRequestType: {
              campaignIds:              plan_ids              || []      
            }
          }
          response = request( auth, Service, 'getAllObjects',options )
          process( response, 'taskId'){ |x| x }
        end

        def self.get_file_id( auth, id)
          raise "empty id" if id.nil?
          response = request(auth, 'task', 'getTaskState',{taskId: id})
          process( response, 'fileId'){ |x| x }
        end

        def self.do_download(auth, id)
          request(auth, 'file', 'download',{fileId: id})
        end

        ###########################
        # interface for operation #
        ###########################
        def self.download( auth, params = {} )
          """
          """
          begin
            result = get_all_object( auth, params )
            if result[:succ]
              task_id = result[:result]
            else
              raise "获取task id 失败"
            end

            puts "task_id: #{task_id}" if ENV["DEBUG"]

            loop do
              file_id = get_file_id( auth, task_id )[:result]
              if file_id.nil?
                sleep 15
                next
              end
              File.open("sm_#{file_id}.zip", "w") do |f|
                f.puts do_download(auth, file_id)
              end
              return
            end
          rescue => e
            p "Error encounter:#{e.to_s}"
          end  
        end

      end
    end
  end
end
