module PPC
  module Operation
    class Group
      include ::PPC::Operation
      
      def info()
        call('group').get(@auth, @id)
      end

      def update( info )
        info[:id] = @id unless info[:id]
        call('group').update(@auth, info)
      end

      # =============================== #
      def keywords()
        call( 'keyword' ).search_by_group_id( @auth, @id )
      end

      def keyword_ids()
        call( 'keyword' ).search_id_by_group_id( @auth, @id )
      end

      def creatives()
        call( 'creative' ).search_by_group_id( @auth, @id )
      end

      def creative_ids()
        call( 'creative' ).search_id_by_group_id( @auth, @id )
      end

      # keyword opeartion
      include ::PPC::Operation::Keyword_operation

      # creative opeartion
      include ::PPC::Operation::Creative_operation

      # Overwrite add method to provide more function
      def add_keyword( keywords )
        call('keyword').add( @auth, add_group_id( keywords ) )
      end

      def add_creative( creatives )
        call('creative').add( @auth, add_group_id( creatives ) )
      end
      
      # Auxilary function
      private
      def add_group_id( types )
        types = [types] unless types.is_a? Array
        types.each do |type|
          type.merge!( {group_id:@id} )
        end
        return types
      end

    end # Group
  end # Operation
end # PPC