module PPC
  module Operation
    module Report

      def query_report( param = nil )
        call('report').get_id( @auth, 'query_report', param )
      end

      def creative_report( param = nil )
        call('report').get_id( @auth, 'creative_report', param )
      end

      def keyword_report( param = nil )
        call('report').get_id( @auth, 'keyword_report', param )
      end

    end
  end
end
