# -*- coding: utf-8 -*-
module PPC
  module Operation
    class Plan
      include ::PPC::Operation

      def groups
        call( "group" ).all( @auth, [@id].flatten )
      end

      def group_ids
        call( "group" ).ids( @auth, [@id].flatten )
      end

      # group opeartion
      include ::PPC::Operation::Group_operation

      # Overwirte add_group method to provide more function
      def add_group( groups )
        call( "group" ).add( @auth, groups.map{|group| group.merge(plan_id: @id)} )
      end


    end # class plan
  end # mudole Opeartion
end # PPC
