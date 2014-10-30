require 'baidu/operation_spec_helper'

  Auth =  {}
  Auth[:username] = $baidu_username
  Auth[:password] = $baidu_password 
  Auth[:token] = $baidu_token
  Auth[:se] = 'baidu'
  preparation = ::PPC::API::Baidu::Group::ids( Auth )
  test_plan_id = preparation[:result][0][:plan_id]
  test_group_id = preparation[:result][0][:group_ids][0]


describe ::PPC::Operation::Account do
  subject{
    ::PPC::Operation::Account.new( Auth )
  }

  it_should_behave_like( "it can operate itself", {budget:2990})
  it_should_behave_like( "it can get all sub_objects", 'plan')

  it_should_behave_like( "it can operate sub_objects", 'plan', {name:'operation_test_plan'},  
                                      {name:'updated_operation_test_plan'})

  it_should_behave_like( "it can operate sub_objects", 'group', 
                                      {name:'test_operation_group',plan_id:test_plan_id, price:500},
                                      {name:'updated_operation_test_group'} )  

  it_should_behave_like( "it can operate sub_objects", 'keyword', 
                                      { keyword:'testKeyword', group_id:test_group_id, match_type:'exact'},
                                      { match_type:'wide'})

  it_should_behave_like( "it can operate sub_objects", 'creative', 
                                       { group_id: test_group_id, 
                                          title: 'OperationTestCreative', preference:1, 
                                          description1:'this is rest',
                                          description2:'also is a test',
                                          pc_destination:$baidu_domain,
                                          pc_display:$baidu_domain },
                                      {title:'OperationTestCreative', 
                                        description1:'this is a updated test',
                                        pc_destination:$baidu_domain,
                                        mobil_destination:$baidu_domain})
end

describe ::PPC::Operation::Plan do
  # get test subject
  subject{
    ::PPC::Operation::Plan.new( Auth.merge({id:test_plan_id}) )
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
    ::PPC::Operation::Group.new( Auth.merge({id:test_group_id}) )
  }

  it_should_behave_like( "it can operate itself", {price:200})
  it_should_behave_like( "it can operate sub_objects", 'keyword', 
                                      { keyword:'testKeyword', group_id:test_group_id, match_type:'exact'},
                                      { match_type:'wide'})
  it_should_behave_like( "it can get all sub_objects", 'keyword')
end

# describe ::PPC::Operation::Keyword do
  # # get test subject
  # subject{
  #   ::PPC::Operation::Keyword.new( Auth.merge({id:?}) )
  # }

  # it_should_behave_like( "it can operate itself", {price:200})
# end

# describe ::PPC::Operation::Creative do
  # # get test subject
  # subject{
  #   ::PPC::Operation::Creative.new( Auth.merge({id:?}) )
  # }

  # it_should_behave_like( "it can operate itself", {price:200})
# end



