describe ::PPC::API::Baidu::Group do
  auth =  {}
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token

  Test_plan_id = []
  Test_group_id = []

  it 'can get all group' do 
    response = ::PPC::API::Baidu::Group::ids( auth )
    is_successed( response ) 
    pair = response['body']['campaignAdgroupIds'][0]
    Test_plan_id << pair['campaignId']
  end

  it 'can add group' do 
    group = { name: 'test_group', plan_id:Test_plan_id[0], price:500 }
    response = ::PPC::API::Baidu::Group::add( auth, group )
    is_success( response )
    Test_group_id << response[:result][0][:id]
  end
  
  it 'can update group' do 
    group = { id: Test_group_id[0], price:600 }
    response = ::PPC::API::Baidu::Group::update( auth, group )
    is_success( response )
  end

  it 'can search group by group id' do
    response = ::PPC::API::Baidu::Group::get( auth, Test_group_id )
    is_success( response )
  end
  
  it 'can search group id by group id' do
    response = ::PPC::API::Baidu::Group::search_id_by_plan_id( auth, Test_plan_id )
    is_success( response )
  end

  it 'search by plan id' do 
    response = ::PPC::API::Baidu::Group::search_by_plan_id( auth, Test_plan_id )
    is_success( response )
  end  

  it 'can delete group' do 
    response = ::PPC::API::Baidu::Group::delete( auth, Test_group_id )
    is_success( response )
  end
  
end
