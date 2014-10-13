describe ::PPC::API::Baidu::Key do
  auth =  {}
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token

  Test_group_id = ::PPC::API::Baidu::Group::all( auth )[0]['adgroupIds'][0]

  def is_successed( response )
    expect( response['header']['desc'] ).to eq 'success'
  end 

  it 'can add keyword' do
    keyword = { group_id: Test_group_id, key: 'elong_test', match_type:'exact' }
    response = ::PPC::API::Baidu::Key::add( auth, keyword, true )
    is_successed( response )
  end

  # it 'can update keyword' do
  # end

  # it 'can active keyword' do
  # end

end
