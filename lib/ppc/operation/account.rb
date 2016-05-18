module PPC
  module Operation
    class Account
      include ::PPC::Operation

      def plans
        call( "plan" ).all( @auth )
      end

      def plan_ids
        call( "plan" ).ids( @auth )
      end
      
      def keywords( group_id )
        call( "keyword" ).all( @auth, group_id )
      end

      def keyword_ids( group_id )
        call( "keyword" ).ids( @auth, group_id )
      end
      
      # plan operations
      include ::PPC::Operation::Plan_operation

      # group opeartions
      include ::PPC::Operation::Group_operation

      # keyword opeartions
      include ::PPC::Operation::Keyword_operation

      # creative opeartions
      include ::PPC::Operation::Creative_operation

      # report operations
      include ::PPC::Operation::Report

    end
  end
end
