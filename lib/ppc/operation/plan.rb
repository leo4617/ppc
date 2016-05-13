# -*- coding: utf-8 -*-
module PPC
  module Operation
    class Plan
      include ::PPC::Operation

      def info
        call('plan').info(@auth,@id)
      end

      def get
        call('plan').get(@auth, @id)
      end

      def update( plan )
        call('plan').update( @auth, plan.merge( id:@id ) )
      end

      def groups()
        call('group').all(@auth, @id)
      end

      def group_ids()
        call('group').ids(@auth, @id)
      end

      def enable
        call('plan').enable(@auth, @id)
      end

      def pause
        call('plan').pause(@auth, @id)
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
