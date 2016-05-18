module PPC
  module Operation
    class Group
      include ::PPC::Operation
      
      def info
        call( "group" ).info( @auth, [@id].flatten )
      end

      def get
        call( "group" ).get( @auth, [@id].flatten )
      end

      def update( group )
        call( "group" ).update( @auth, [group.merge(id: @id)].flatten )
      end

      def keywords
        call( "keyword" ).all( @auth, [@id].flatten )
      end

      def keyword_ids
        call( "keyword" ).ids( @auth, [@id].flatten )
      end

      def creatives
        call( "creative" ).all( @auth, [@id].flatten )
      end

      def creative_ids
        call( "creative" ).ids( @auth, [@id].flatten )
      end

      def delete
        call( "group" ).delete( @auth, [@id].flatten )
      end

      def activate
        call( "keyword" ).enable( @auth, [@id].flatten )
      end

      def enable
        call( "group" ).enable( @auth, [@id].flatten )
      end

      def pause
        call( "group" ).pause( @auth, [@id].flatten )
      end

      # keyword opeartion
      include ::PPC::Operation::Keyword_operation

      # creative opeartion
      include ::PPC::Operation::Creative_operation

      # Overwrite add method to provide more function
      def add_keyword( keywords )
        call( "keyword" ).add( @auth, keywords.map{|keyword| keyword.merge(group_id: @id)} )
      end

      def add_creative( creatives )
        call( "creative" ).add( @auth, creatives.map{|creative| creative.merge(group_id: @id)} )
      end
      
    end # Group
  end # Operation
end # PPC
