describe ::PPC::API::Qihu::Sublink do
  auth = $qihu_auth

  test_plan_id = ::PPC::API::Qihu::Plan::ids( auth )[:result][0].to_i
  test_group_id = ::PPC::API::Qihu::Group::search_id_by_plan_id( auth, test_plan_id )[:result][0][:group_ids][0].to_i
  test_sublink_id = 0

  it 'can add a sublink' do
    sublink1 = { 
                            group_id:test_group_id, 
                            anchor: "shushide", 
                            url: 'http://hotel.elong.com'
                          }
    response =  ::PPC::API::Qihu::Sublink::add( auth, sublink1)
    is_success( response )
    test_sublink_id = response[:result][0][:id]
  end

  it 'can update a sublink' do
     sublink = { id: test_sublink_id, anchor: 'testaaaaa' }
     response =  ::PPC::API::Qihu::Sublink::update( auth, sublink )
     is_success( response )
  end 

  it 'can get sublinks' do
    response =  ::PPC::API::Qihu::Sublink::get( auth, test_sublink_id )
    is_success( response )
    expect( response[:result][0].keys ).to include( :id, :anchor )
  end

  it 'can delete a sublink' do
      response =  ::PPC::API::Qihu::Sublink::delete( auth, test_sublink_id )
      is_success( response )
  end
  
end
