module PPC
  module Operation
    class Keyword
      include ::PPC::Operation

      def info
        call( "keyword" ).info( @auth, [@id].flatten )
      end

      def get
        call( "keyword" ).get( @auth, [@id].flatten )
      end

      def update( keyword )
        call( "keyword" ).update( @auth, [keyword.merge(id: @id)].flatten )
      end

      def delete
        call( "keyword" ).delete( @auth, [@id].flatten )
      end

      def activate
        call( "keyword" ).enable( @auth, [@id].flatten )
      end

      def enable
        call( "keyword" ).enable( @auth, [@id].flatten )
      end

      def pause
        call( "keyword" ).pause( @auth, [@id].flatten )
      end
      
      def status
        call( "keyword" ).status( @auth, [@id].flatten )
      end

      def quality
        call( "keyword" ).quality( @auth, [@id].flatten )
      end

    end
  end
end
