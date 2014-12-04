module PPC
  module Operation
    class Account
      include ::PPC::Operation

      def info
        info = call('account').info(@auth)
        p info
        @id = info[:result][:id] if @id == nil
        return info
      end

      def update(account)
        call('account').update(@auth,account)
      end

      # plan methods
      def plans
        call('plan').all(@auth)
      end

      def plan_ids
        call('plan').ids(@auth)
      end
      
      # some useful keyword methods
      def keywords(group_id)
        call( 'keyword' ).search_by_group_id( @auth, group_id )
      end

      def keyword_ids(group_id)
        call( 'keyword' ).search_id_by_group_id( @auth, group_id )
      end

      # report methods, only support baidu and sogou 
      def get_report_id( param )
        """
        Acquire professional report id,
        
        """
        call( 'report' ).get_id( @auth, param )
      end

      def get_report_status( id )
        call( 'report' ).get_status( @auth, id )
      end

      def get_report_url( id )
        call( 'report' ).get_url( @auth, id )
      end

      
      # plan operation
      include ::PPC::Operation::Plan_operation

      # group opeartion
      include ::PPC::Operation::Group_operation

      # keyword opeartion
      include ::PPC::Operation::Keyword_operation

      # creative opeartion
      include ::PPC::Operation::Creative_operation

    end
  end
end
