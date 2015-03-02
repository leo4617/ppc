describe ::PPC::API::Sogou::Account do
  auth = $sogou_auth

  it 'can get account info' do
      result = ::PPC::API::Sogou::Account::info( auth )
      is_success( result )
      expect(result[:result][:id].to_i).to be > 0 
  end

  it 'can update account' do
    update = {budget:0}
    result =  ::PPC::API::Sogou::Account::update( auth, update )
    is_success( result )
    expect(result[:result][:id].to_i).to be > 0 
  end

end
