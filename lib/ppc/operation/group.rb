module PPC
  module Operation
    class Group
      include ::PPC::Operation
      
      def info()
        call('group').info(@auth, @id)
      end

      def get
        call('group').get(@auth, @id)
      end

      def update( info )
        info[:id] = @id if (info.is_a? Hash) && info[:id].nil?
        call('group').update(@auth, info)
      end

      # =============================== #
      def keywords()
        call( 'keyword' ).all( @auth, @id )
      end

      def keyword_ids()
        call( 'keyword' ).ids( @auth, @id )
      end

      def creatives()
        call( 'creative' ).all( @auth, @id )
      end

      def creative_ids()
        call( 'creative' ).ids( @auth, @id )
      end

      def enable
        call('group').enable(@auth, @id)
      end

      def pause
        call('group').pause(@auth, @id)
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
