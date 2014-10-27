module PPC
  module Operation
    class Keyword
      include ::PPC::Operation

      def info()
        ::PPC::API::Baidu::Keyword::get( @auth, @id )
      end

      def update( type )
        ::PPC::API::Baidu::Keyword::update( @auth, type.merge( id:@id) )
      end

      def activate()
        ::PPC::API::Baidu::Keyword::activate( @auth, @id )
      end
      
      def status()
        ::PPC::API::Baidu::Keyword::status( @auth, @id )
      end

      def quality()
        ::PPC::API::Baidu::Keyword::quality( @auth, @id )
      end

      def delete()
        ::PPC::API::Baidu::Keyword::delete( @auth, @id )
      end

    end
  end
end