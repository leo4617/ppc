module PPC
  class Baidu
    class Group < ::PPC::Baidu
      def initialize(params = {})
        params[:service] = 'Adgroup'
        super(params)
      end

      def all()
        request("getAllAdgroupId")
      end

    end
  end
end