describe ::PPC::API::Qihu::Sublink do
  auth = $qihu_auth

  test_plan_id = ::PPC::API::Qihu::Account::ids( auth )[:result][0].to_i
  test_group_id = ::PPC::API::Qihu::Group::search_id_by_plan_id( auth, test_plan_id )[:result][0].to_i
  test_Creative_id = 0

  it 'can search creatives by group id' do
    response = ::PPC::API::Qihu::Creative::search_id_by_group_id( auth, test_group_id )
    is_success( response)
    expect( response[:result].class ).to eq Array
  end

  it 'can add a sublink' do
    sublink1 = { 
                            group_id:test_group_id, 
                            anchor: "shushidejiudian", 
                            url: 'http://hotel.elong.com'
                          }
    response =  ::PPC::API::Qihu::Sublink::add( auth, sublink1)
    is_success( response )
    test_sublink_id = response[:result][0]
  end

  it 'can update a sublink' do
     sublink = { id:test_sublink_id, anchor:'testaaaaa' }
     response =  ::PPC::API::Qihu::Creative::update( auth, sublink )
     is_success( response )
  end 

  it 'can get sublinks' do
    response =  ::PPC::API::Qihu::Sublink::get( auth, test_sublink_id )
    is_success( response )
    expect( response[:result][0].keys ).to include( :id, :text )
  end

  it 'can delete a sublink' do
      response =  ::PPC::API::Qihu::Sublink::delete( auth, test_sublink_id )
      is_success( response )
  end
  
end
