describe ::PPC::API::Baidu::Keyword do
  auth =  {}
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token

  Test_group_id = ::PPC::API::Baidu::Group::ids( auth )[:result][0]['adgroupIds'][0]
  Test_plan_id = ::PPC::API::Baidu::Plan::all( auth )[:result][0]['campaignId']
  Test_keyword_id = []

  Test_domain = $baidu_domain

  it 'can search keyword by group id' do
    response = ::PPC::API::Baidu::Keyword::search_by_group_id( auth, Test_group_id )
    is_success( response )
  end

  it 'can add keyword' do
    keyword = { group_id: Test_group_id, keyword: 'Test', match_type:'exact' }
    response = ::PPC::API::Baidu::Keyword::add( auth, keyword )
    is_success( response )
    Test_keyword_id << response[:result][0][:id]
  end

  it 'can update keyword' do
    update = { id:Test_keyword_id[0],  pc_destination: Test_domain, pause:true} 
    response = ::PPC::API::Baidu::Keyword::update( auth, update )
    is_success( response )
  end

  it 'can activate keyword' do
    response = ::PPC::API::Baidu::Keyword::activate( auth, Test_keyword_id )
    is_success( response )
  end

  it 'can get status' do
    response1 = ::PPC::API::Baidu::Keyword::status( auth, Test_group_id, 'group' )
    response2 = ::PPC::API::Baidu::Keyword::status( auth, Test_keyword_id, 'keyword' )
    response3 = ::PPC::API::Baidu::Keyword::status( auth, Test_plan_id, 'plan' )
    is_success( response1 ) 
    is_success( response2 ) 
    is_success( response3 ) 
  end

  # it 'can get quality' do
  #   response1 = ::PPC::API::Baidu::Keyword::quality( auth, Test_group_id, 'group', true )
  #   response2 = ::PPC::API::Baidu::Keyword::quality( auth, Test_keyword_id, 'keyword', true )
  #   response3 = ::PPC::API::Baidu::Keyword::quality( auth, Test_plan_id, 'plan', true )
  #   is_successed( response1 ) 
  #   is_successed( response2 ) 
  #   is_successed( response3 ) 
  # end

  it 'can get 10-quality' do
    response = ::PPC::API::Baidu::Keyword::quality( auth, Test_keyword_id, 'keyword', 'pc' )
    is_success( response )    
  end

  it 'can delete keyword' do
    response = ::PPC::API::Baidu::Keyword::delete( auth, Test_keyword_id )
    is_success( response )
  end

end
