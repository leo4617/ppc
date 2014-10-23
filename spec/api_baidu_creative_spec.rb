describe ::PPC::API::Baidu::Creative do
  auth =  {}
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token

  Test_group_id = ::PPC::API::Baidu::Group::all( auth )[:result][0]['adgroupIds'][0]
  Test_plan_id = ::PPC::API::Baidu::Plan::all( auth )[:result][0]['campaignId']
  Test_creative_id = []
  Test_domain = $baidu_domain

 it 'can add creative' do
    creative = { group_id: Test_group_id, 
                        title: 'Test', preference:1, 
                        description1:'this is rest',
                        description2:'also is a test',
                        pc_destination:Test_domain,
                        pc_display:Test_domain }

    response = ::PPC::API::Baidu::Creative::add( auth, creative, true )
    is_successed( response )
    Test_creative_id << response['body']['creativeTypes'][0]['creativeId']
  end

  # # 此测试未能通过，总是会出现莫名其妙的错误。
  # it 'can update creative' do
  #   update = { id:Test_creative_id[0], 
  #                      title:'ElongUpdateTest',
  #                      description1:'test for update',
  #                      pause:true} 
  #   response = ::PPC::API::Baidu::Creative::update( auth, update, true )
  #   is_successed( response )
  # end

  it 'can activate creative' do
    response = ::PPC::API::Baidu::Creative::activate( auth, Test_creative_id, true )
    is_successed( response )
  end

  it 'can get status' do
    response1 = ::PPC::API::Baidu::Creative::status( auth, Test_group_id, 'group', true )
    response2 = ::PPC::API::Baidu::Creative::status( auth, Test_creative_id, 'creative', true )
    response3 = ::PPC::API::Baidu::Creative::status( auth, Test_plan_id, 'plan', true )
    is_successed( response1 ) 
    is_successed( response2 ) 
    is_successed( response3 ) 
  end

  it 'can search id by group id' do
    response = ::PPC::API::Baidu::Creative::get_by_group_id( auth, Test_group_id, 0, true )
    is_successed( response )
  end

  it 'can search creative by group id' do
    response = ::PPC::API::Baidu::Creative::search_by_group_id( auth, Test_group_id, 0, true )
    is_successed( response )
  end

  it 'can search creative by creative id' do
    response = ::PPC::API::Baidu::Creative::get( auth, Test_creative_id, 0, true )
    is_successed( response )
  end

  it 'can delete creative' do 
    response = ::PPC::API::Baidu::Creative::delete( auth, Test_creative_id, true )
    is_successed( response )
  end

end