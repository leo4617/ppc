module PPC
  module Operation
    class Account
      include ::PPC::Operation

      def info
        call('account').info(@auth)
      end

      def update(account)
        call('account').info(@auth,account)
      end

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

      def delete_plans(ids)
        call('plan').delete(@auth,ids)
      end

      def group_ids
        call('group').all
      end

      def update_group(id,group)
        group[:id] = id
        call('group').update(@auth,group)
      end

      def update_groups(groups)
        call('groups').update(@auth,groups)
      end
    end
  end
end
