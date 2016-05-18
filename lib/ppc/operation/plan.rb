# -*- coding: utf-8 -*-
module PPC
  module Operation
    class Plan
      include ::PPC::Operation

      def info
        call( "plan" ).info( @auth, [@id].flatten )
      end

      def get
        call( "plan" ).get( @auth, [@id].flatten )
      end

      def update( plan )
        call( "plan" ).update( @auth, [plan.merge(id: @id)].flatten )
      end

      def groups
        call( "group" ).all( @auth, [@id].flatten )
      end

      def group_ids
        call( "group" ).ids( @auth, [@id].flatten )
      end

      def delete
        call( "plan" ).delete( @auth, [@id].flatten )
      end

      def activate
        call( "plan" ).enable( @auth, [@id].flatten )
      end

      def enable
        call( "plan" ).enable( @auth, [@id].flatten )
      end

      def pause
        call( "plan" ).pause( @auth, [@id].flatten )
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
