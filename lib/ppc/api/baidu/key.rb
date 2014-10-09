module PPC
  module Baidu
    class Key
      include ::PPC::Baidu
      def initialize(params = {})
        params[:service] = 'Keyword'
        @se_id = params[:se_id]
        super(params)
      end

      def add()
      end

      def update()
      end

      def self.delete(params = {})

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