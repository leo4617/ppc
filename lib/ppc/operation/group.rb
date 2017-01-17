module PPC
  module Operation
    class Group
      include ::PPC::Operation

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

      def sublinks
        call( "sublink" ).all( @auth, [@id].flatten )
      end

      def sublink_ids
        call( "sublink" ).ids( @auth, [@id].flatten )
      end

      # keyword opeartion
      include ::PPC::Operation::Keyword_operation

      # creative opeartion
      include ::PPC::Operation::Creative_operation

      # sublink opeartion
      include ::PPC::Operation::Sublink_operation

      # Overwrite add method to provide more function
      def add_keyword( keywords )
        call( "keyword" ).add( @auth, keywords.map{|keyword| keyword.merge(group_id: @id)} )
      end

      def add_creative( creatives )
        call( "creative" ).add( @auth, creatives.map{|creative| creative.merge(group_id: @id)} )
      end

      def search_keyword( keyword )
        call( "keyword" ).search( @auth, {group_id: @id, keyword: keyword})
      end
      
    end # Group
  end # Operation
end # PPC
