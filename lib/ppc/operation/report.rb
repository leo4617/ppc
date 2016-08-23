module PPC
  module Operation
    module Report

      def download_report( param = {}, debug = false )
        call( "report" ).download_report( @auth, param, debug )
      end

      def query_report( param = {}, debug = false )
        call( "report" ).query_report( @auth, param, debug )
      end

      def creative_report( param = {}, debug = false )
        call( "report" ).creative_report( @auth, param, debug )
      end

      def keyword_report( param = {}, debug = false )
        call( "report" ).keyword_report( @auth, param, debug )
      end

    end
  end
end
