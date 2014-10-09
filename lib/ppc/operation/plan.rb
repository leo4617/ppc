module PPC
  module Operation
    class Plan
      include ::PPC::Operation
      def update(plan)
        call('plan').update(@auth,plan)
      end

      def info
        call('plan').get(@auth,@id)
      end

      def delete
        call('plan').delete(@auth,@id)
      end

      def add_groups(groups)
        groups = [groups] unless groups.is_a?Array
        groups.each do |group|
          group[:plan_id] = @id
        end

        call('group').add(@auth,groups)
      end
    end
  end
end
