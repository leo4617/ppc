# -*- coding: utf-8 -*-
module PPC
  module Operation
    class Plan
      include ::PPC::Operation

      def info
        call('plan').get(@auth,@id)
      end

      def update( plan )
        call('plan').update( @auth, plan.merge( id:@id ) )
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

      # group opeartion
      include ::PPC::Operation::Group_operation

      # Overwirte add_group method to provide more function
      def add_group( groups )
        call('group').add( @auth, add_plan_id( groups ) )
      end

      # Auxilary function
      private
      def add_plan_id( types )
        types = [types] unless types.is_a? Array
        types.each do |type|
          type.merge!({plan_id:@id})
        end
        return types
      end

    end # class plan
  end # mudole Opeartion
end # PPC
