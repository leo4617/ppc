module PPC
  module Operation
    class Account
      include ::PPC::Operation

      # self operations
      def info
        info = call('account').info(@auth)
        @id = info[:result][:id] if @id == nil
        return info
      end

      def update(account)
        call('account').update(@auth,account)
      end

      # subobject(plan) operations
      def plans
        call('plan').all(@auth)
      end

      def plan_ids
        call('plan').ids(@auth)
      end
      
      # some useful keyword operations
      def keywords(group_id)
        call( 'keyword' ).all( @auth, group_id )
      end

      def keyword_ids(group_id)
        call( 'keyword' ).ids( @auth, group_id )
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
