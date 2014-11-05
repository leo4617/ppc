describe ::PPC::API::Qihu::Group do
  auth = {}
  auth[:token] = $qihu_token
  auth[:accessToken] =  $qihu_accessToken

  test_plan_id = ::PPC::API::Qihu::Account::ids( auth )[:result][0].to_i
  test_group_id = 0 

  it 'can add group' do
    group = { plan_id:test_plan_id, name:'testGroup', price:999}
    response = ::PPC::API::Qihu::Group::add( auth, group)
    is_success(response)
    test_group_id = response[:result].to_i
  end

  it 'can update group' do
    group = { id: test_group_id, price:990}
    response = ::PPC::API::Qihu::Group::update( auth, group )
    is_success(response)
  end

  it 'can get group' do
    response = ::PPC::API::Qihu::Group::get( auth, test_group_id )
    is_success( response )
  end

  it 'can search id by plan id ' do
    response = ::PPC::API::Qihu::Group::search_id_by_plan_id( auth, test_plan_id )
    is_success( response )
  end

  it 'can delete group' do
    response = ::PPC::API::Qihu::Group::delete( auth, test_group_id)
    is_success( response )   
  end

end