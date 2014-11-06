describe ::PPC::API::Qihu::Creative do
  auth = {}
  auth[:token] = $qihu_token
  auth[:accessToken] = $qihu_accessToken

  test_plan_id = ::PPC::API::Qihu::Account::ids( auth )[:result][0].to_i
  test_group_id = ::PPC::API::Qihu::Group::search_id_by_plan_id( auth, test_plan_id )[:result][0].to_i
  test_Creative_id = 0

  it 'can search Creative by group id' do
    response = ::PPC::API::Qihu::Creative::search_id_by_group_id( auth, test_group_id )
    is_success( response)
    expect( response[:result].class ).to eq Array
  end

  it 'can add Creative' do
    creative1 = { 
                            group_id:test_group_id, 
                            title:"testCreative1", 
                            description1:'testhahaa',
                            pc_destination:'www.elong.com'
                          }
    response =  ::PPC::API::Qihu::Creative::add( auth, creative1)
    is_success( response )
    test_Creative_id = response[:result][0]
    p response
  end

  it 'can update Creative' do
     creative = { id:test_Creative_id, description2:'testaaaaa' }
     response =  ::PPC::API::Qihu::Creative::update( auth, creative )
     is_success( response )
  end 

  it 'can get creative' do
    response =  ::PPC::API::Qihu::Creative::get( auth, test_Creative_id )
    is_success( response )
    expect( response[:result][0].keys ).to include( :id, :title )
  end

  it 'can get status' do
      response =  ::PPC::API::Qihu::Creative::status( auth, test_Creative_id )
      is_success( response )
  end

  it 'can delete Creative' do
      response =  ::PPC::API::Qihu::Creative::delete( auth, test_Creative_id )
      is_success( response )
  end
  
end