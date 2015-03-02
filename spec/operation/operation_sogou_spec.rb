require_relative 'operation_spec_helper'

auth = $sogou_auth
preparation = ::PPC::API::Sogou::Group::ids( auth )
test_plan_id = preparation[:result][0][:plan_id]
test_group_id = preparation[:result][0][:group_ids][0]
test_keyword_id = 2517133587
test_creative_id = 1519567392

::PPC::API::Sogou.debug_on

describe ::PPC::Operation::Account do
  subject{
    ::PPC::Operation::Account.new( auth )
  }

  it_should_behave_like( "object", {budget:2990})
  it_should_behave_like( "object parent", 'plan')

  it_should_behave_like( "object operator", 'plan', {name:'operation_test_plan'},  
                                      {name:'updated_operation_test_plan'})

  it_should_behave_like( "object operator", 'group', 
                                      {name:'test_operation_group',plan_id:test_plan_id, price:500},
                                      {name:'updated_operation_test_group'} )  

  # report test
  it 'can get report' do
    endDate = ( Time.now-2*3600*24).to_s[0..9].split('-').join
    startDate =( Time.now-27*3600*24).to_s[0..9].split('-').join

    param = {startDate:startDate, endDate:endDate}

    subject.query_report( param )
    subject.keyword_report( param )
    subject.creative_report( param )
  end

end

describe ::PPC::Operation::Plan do
  # get test subject
  subject{
    ::PPC::Operation::Plan.new( auth.merge({id:test_plan_id}) )
  }

  it_should_behave_like( "object", {budget:2000})
  it_should_behave_like( "object operator", 'group', 
                                      {name:'test_operation_group', price:500},
                                      {name:'updated_operation_test_group'} )  
  it_should_behave_like( "object parent", 'group')
end

describe ::PPC::Operation::Group do
  # get test subject
  subject{
    ::PPC::Operation::Group.new( auth.merge({id:test_group_id}) )
  }

  it_should_behave_like( "object", {price:200})
  it_should_behave_like( "object parent", 'keyword')
end

describe ::PPC::Operation::Keyword do
  # keyword subject
  subject{
    ::PPC::Operation::Keyword.new( auth.merge({id:test_keyword_id}) )
  }

  it 'can get info' do
    is_success( subject.info )
  end
end

describe ::PPC::Operation::Creative do
  # creative subject
  subject{
    ::PPC::Operation::Creative.new( auth.merge({id:test_keyword_id}) )
  }

  it 'can get info' do
    is_success( subject.info )
  end
end




