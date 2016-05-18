module PPC
  module Operation
    class Creative 
      include ::PPC::Operation

      def info
        call( "creative" ).info( @auth, [@id].flatten )
      end

      def get
        call( "creative" ).get( @auth, [@id].flatten )
      end

      def update( creative )
        call( "creative" ).update( @auth, [creative.merge(id: @id)].flatten )
      end

      def delete
        call( "creative" ).delete( @auth, [@id].flatten )
      end

      def activate
        call( "creative" ).enable( @auth, [@id].flatten )
      end

      def enable
        call( "creative" ).enable( @auth, [@id].flatten )
      end

      def pause
        call( "creative" ).pause( @auth, [@id].flatten )
      end

      def status
        call( "creative" ).status( @auth, [@id].flatten )
      end

      def delete
        call( "creative" ).delete( @auth, [@id].flatten )
      end

    end
  end
end
