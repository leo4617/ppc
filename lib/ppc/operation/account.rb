module PPC
  module Operation
    class Account
      include ::PPC::Operation

      def info
        info = call('account').info(@auth)
        @id = info[:result][0][:id] if @id == nil
        return info
      end

      def update(account)
        call('account').update(@auth,account)
      end

      # plan methods
      def plans
        call('plan').all(@auth)
      end

      def plan_ids
        call('plan').ids(@auth)
      end

      def get_plan(ids)
        call('plan').get(@auth,ids)
      end

      def add_plan(plans)
        call('plan').add(@auth,plans)
      end

      def update_plan(plans)
        call('plan').update(@auth,plans)
      end

      def delete_plan(ids)
        call('plan').delete(@auth,ids)
      end

      # group methods
      def add_group(group)
        call('group').add(@auth,group)
      end

      def update_group(group)
        call('group').update(@auth,group)
      end

      def delete_group(ids)
        call('group').delete(@auth,ids)
      end

      def get_group(ids)
        call('group').get(@auth,ids)
      end

      # keyword method

    end
  end
end
