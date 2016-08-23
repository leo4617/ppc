# -*- coding:utf-8 -*-
require "open-uri"
require "zip"
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

        def self.get_cpc_rank(auth, device)
          body = {'deviceType' => device}
          response = request(auth, 'CpcRank', 'getCpcRankId', body)
          process(response, 'rankId'){|x| x}
        end

        def self.get_cpc_rank_status(auth, rank_id)
          body = {'rankId' => rank_id}
          response = request(auth, 'CpcRank', 'getCpcRankStatus', body)
          process(response, 'isGenerated' ){|x| x }
        end

        def self.get_cpc_rank_path(auth, rank_id)
          body = {'rankId' => rank_id}
          response = request(auth, 'CpcRank', 'getCpcRankPath', body)
          process(response, 'rankPath'){|x| x}
        end

        def self.download_cpc_rank(auth, device = 0)
          result = get_cpc_rank(auth, device)
          rank_id = result[:result]
          times = 0
          loop do 
            raise "The speed of get_status is too slow." if (times += 1) > 10
            status = get_cpc_rank_status(auth, rank_id)
            return get_cpc_rank_path(auth, rank_id) if status[:result] == '1'
            sleep 10
          end
        end

        def self.rank_report(auth, device = 0, debug)
          url = download_cpc_rank(auth, device)[:result]
          file = "sogou_rank_#{Time.now.to_i}.zip"
          File.open(file, "w"){|f| f.puts open(url).read} 
          content = Zip::File.open(file) do |zip_file|
            entry = zip_file.glob('*.csv').first
            content = entry.get_input_stream.read.force_encoding('gb18030').encode('utf-8')
          end
          File.delete(file)
          content
        end

      end
    end
  end
end
