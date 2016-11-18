module PPC
  module Operation
    module Report

      def download_report( param = {} )
        call( "report" ).download_report( @auth, param )
      end

      def query_report( param = {} )
        call( "report" ).query_report( @auth, param )
      end

      def creative_report( param = {} )
        call( "report" ).creative_report( @auth, param )
      end

      def keyword_report( param = {} )
        call( "report" ).keyword_report( @auth, param )
      end

      def account_report( param = {} )
        call( "report" ).account_report( @auth, param )
      end

      def plan_report( param = {} )
        call( "report" ).plan_report( @auth, param )
      end

      def group_report( param = {} )
        call( "report" ).group_report( @auth, param )
      end

      def rank_report( device = 0 )
        call( "bulk" ).rank_report( @auth, device )
      end

    end
  end
end
