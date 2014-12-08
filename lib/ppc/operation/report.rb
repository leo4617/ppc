module PPC
  module Operation
    module Report

      def query_report( param = nil, debug = false )
        param = {} if not param
        param[:type]   ||= 'pair'
        param[:fields] ||=  %w(click impression)
        param[:level]  ||= 'pair'
        param[:range]  ||= 'account'
        param[:unit]   ||= 'day'
        download_report( param, debug )
      end

      def creative_report( param = nil, debug = false )
        param = {} if not param
        param[:type]   ||= 'creative'
        param[:fields] ||=  %w(impression click cpc cost ctr cpm position conversion)
        param[:level]  ||= 'creative'
        param[:range]  ||= 'creative'
        param[:unit]   ||= 'day'
        download_report( param, debug )
      end

      def keyword_report( param = nil, debug = false )
        param = {} if not param
        param[:type]   ||= 'keyword'
        param[:fields] ||=  %w(impression click cpc cost ctr cpm position conversion)
        param[:level]  ||= 'keywordid'
        param[:range]  ||= 'keywordid'
        param[:unit]   ||= 'day'
        download_report( param, debug )
      end
 
      def download_report( param, debug = false )
        response = call('report').get_id( @auth, param )
        if response[:succ]
          id = response[:result]
          p "Got report id:" + id.to_s if debug 
          loop do
            sleep 3 
            break if call('report').get_state( @auth, id )[:result] == 'Finished'
            p "Report is not generated, waiting..." if debug 
          end

          url = call('report').get_url( @auth, id )[:result]
          return open(url).read.force_encoding('gb18030').encode('utf-8')
        else
          raise response[:failure][0]["message"]
        end
      end

    end
  end
end
