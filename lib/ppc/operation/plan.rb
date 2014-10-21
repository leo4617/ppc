# -*- coding: utf-8 -*-
module PPC
  module Operation
    class Plan
      include ::PPC::Operation

      def info
        call('plan').get(@auth,@id)
      end

      def update(plan)
        call('plan').update(@auth,plan)
      end

      # group methods 尽管很想做成module一个include 就行
      # 但是每一层操作都有细微不同

      def get_group(id)
        """
        不支持批量操作，一次只返回一个group对象。
        """
        unless id.is_a? Integer
          p "Do not support bulk operation, please input an integer."
          return
        end

        ::PPC::Operation::Group.new( {id:id, se:@se, auth:@auth} )
      end

      def groups()
        result = call('group').search_by_plan_id(@auth, @id)
        result[:result] = result[:result][0][:groups]
        return result
      end

      def group_ids()
        result = call('group').search_id_by_plan_id(@auth, @id)
        result[:result] = result[:result][0][:group_ids]
        return result
      end

      def add_group(groups)

      end
      
      def update_group(groups)

      end

      def delete_group(ids)

      end

    end # class plan
  end # mudole Opeartion
end # PPC
