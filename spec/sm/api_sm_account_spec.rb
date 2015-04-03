describe ::PPC::API::Sm::Account do
  auth = $sm_auth
  
  it 'can get account info' do
      result = ::PPC::API::Sm::Account::info( auth )
      is_success( result )
  end
end
