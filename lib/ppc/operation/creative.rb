module PPC
  module Operation
    class Creative 
      include ::PPC::Operation

      def info()
        call( 'creative' ).get( @auth, @id )
      end

      def update( type )
        call( 'creative' ).update( @auth, type.merge( id:@id) )
      end

      def activate()
        call( 'creative' ).activate( @auth, @id )
      end

      def enable
        call( 'creative' ).enable( @auth, @id )
      end

      def pause
        call( 'creative' ).pause( @auth, @id )
      end

      def status()
        call( 'creative' ).status( @auth, @id )
      end

      def delete()
        call( 'creative' ).delete( @auth, @id )
      end

    end
  end
end
