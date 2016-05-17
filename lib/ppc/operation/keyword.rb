module PPC
  module Operation
    class Keyword
      include ::PPC::Operation

      def info()
        call( 'keyword' ).info( @auth, @id )
      end

      def get()
        call( 'keyword' ).get( @auth, @id )
      end

      def update( type )
        type.merge(id: @id) if type.is_a? Hash
        call( 'keyword' ).update( @auth, type )
      end

      # Todo: Implement Activate method in Sogou API
      def activate()
        call( 'keyword' ).activate( @auth, @id )
      end

      def enable
        call('keyword').enable(@auth, @id)
      end

      def pause
        call('keyword').pause(@auth, @id)
      end
      
      def status()
        call( 'keyword' ).status( @auth, @id )
      end

      def quality()
        call( 'keyword' ).quality( @auth, @id )
      end

      def delete( ids = nil )
        ids ||= @id
        call( 'keyword' ).delete( @auth, ids )
      end

    end
  end
end
