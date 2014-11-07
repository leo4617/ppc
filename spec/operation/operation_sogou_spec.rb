require 'operation/operation_spec_helper'

  auth =  {}
  auth[:username] = $sogou_username
  auth[:password] = $sogou_password
  auth[:token] = $sogou_token
  auth[:se] = 'sogou'
  preparation = ::PPC::API::Sogou::Group::ids( auth )
  test_plan_id = preparation[:result][0][:plan_id]
  test_group_id = preparation[:result][0][:group_ids][0]
   ::PPC::API::Sogou.debug_on

describe ::PPC::Operation::Account do
  subject{
    ::PPC::Operation::Account.new( auth )
  }

  it_should_behave_like( "it can operate itself", {budget:2990})
  it_should_behave_like( "it can get all sub_objects", 'plan')

  it_should_behave_like( "it can operate sub_objects", 'plan', {name:'operation_test_plan'},  
                                      {name:'updated_operation_test_plan'})

  it_should_behave_like( "it can operate sub_objects", 'group', 
                                      {name:'test_operation_group',plan_id:test_plan_id, price:500},
                                      {name:'updated_operation_test_group'} )  

end

describe ::PPC::Operation::Plan do
  # get test subject
  subject{
    ::PPC::Operation::Plan.new( auth.merge({id:test_plan_id}) )
  }

  it_should_behave_like( "it can operate itself", {budget:2000})
  it_should_behave_like( "it can operate sub_objects", 'group', 
                                      {name:'test_operation_group', price:500},
                                      {name:'updated_operation_test_group'} )  
  it_should_behave_like( "it can get all sub_objects", 'group')
end

describe ::PPC::Operation::Group do
  # get test subject
  subject{
    ::PPC::Operation::Group.new( auth.merge({id:test_group_id}) )
  }

  it_should_behave_like( "it can operate itself", {price:200})
  it_should_behave_like( "it can get all sub_objects", 'keyword')
end



