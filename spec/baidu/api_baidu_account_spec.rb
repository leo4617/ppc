describe ::PPC::API::Baidu::Account do
  auth = $baidu_auth
  #::PPC::API::Baidu.debug_on
  
  it 'can get account info' do
      result = ::PPC::API::Baidu::Account::info auth 
      is_success result 
  end

  it 'can update account' do
    update = {budget_type: 1, budget: 1000}
    result =  ::PPC::API::Baidu::Account::update(auth, update)
    is_success result 
  end

end
