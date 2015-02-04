module PPC
  module Operation
    class Creative 
      include ::PPC::Operation

      def info()
        ::PPC::API::Baidu::Creative::get( @auth, @id )
      end

      def update( type )
        ::PPC::API::Baidu::Keyword::update( @auth, type.merge( id:@id) )
      end

      def activate()
        ::PPC::API::Baidu::Creative::activate( @auth, @id )
      end

      def status()
        ::PPC::API::Baidu::Creative::status( @auth, @id )
      end

      def delete()
        ::PPC::API::Baidu::Creative::delete( @auth, @id )
      end

    end
  end
end
