describe ::PPC::API::Sogou::Account do
  auth =  {}
  auth[:username] = $sogou_username
  auth[:password] = $sogou_password
  auth[:token] = $sogou_token

  it 'can get account info' do
      result = ::PPC::API::Sogou::Account::info( auth )
      is_success( result )
  end

  it 'can update account' do
    update = {budget:500}
    result =  ::PPC::API::Sogou::Account::update( auth, update )
    is_success( result )
  end

end
