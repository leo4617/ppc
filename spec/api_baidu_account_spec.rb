describe ::PPC::API::Baidu::Account do
  auth =  {}
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token
  
  it 'can get account info' do
      result = ::PPC::API::Baidu::Account::info( auth, true )
      is_successed( result )
       result = ::PPC::API::Baidu::Account::info( auth )
  end

  it 'can update account' do
    update = {budget:2990}
    result =  ::PPC::API::Baidu::Account::update( auth, update, true )
    is_successed( result )

  end

end
