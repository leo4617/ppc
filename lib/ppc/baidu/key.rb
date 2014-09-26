module PPC
    class Key < ::PPC::Baidu
  module Baidu
      def initialize(params = {})
        params[:service] = 'Keyword'
        @se_id = params[:se_id]
        super(params)
      end 

      def add()
      end

      def update()
      end

      def delete()
      end

      def active()
      end

      def search_by_groupid( ids, return_id = false )
      end

      def search_by_keywordid( ids )
      end

      def get_status()
      end

      def get_quality()
      end

      def get_10quality()
      end
    end
  end
end