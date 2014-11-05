describe ::PPC::API::Qihu::Account do
  auth = {  }
  auth[:token] = $qihu_token
  auth[:accessToken] = $qihu_accessToken

  it 'can get info' do
    response = ::PPC::API::Qihu::Account::info( auth )
    is_success( response )
    expect( response[:result].keys ).to eq [:id, :name, :email, :company, :industry1, :industry2, :balance, :budget, :open_domains]
  end

  it 'can update exclude iplist' do
    response = ::PPC::API::Qihu::Account::update_exclude_ip( auth, ['127.0.0.1'] )
    is_success( response )
  end

  it 'can get exclude ip list' do
    response = ::PPC::API::Qihu::Account::get_exclude_ip( auth )
    is_success( response )
  end

  it 'can update budget' do
    response = ::PPC::API::Qihu::Account::update_budget( auth, 3500 )
    is_success( response )
  end

  it ' can get all plan ids ' do
     response = ::PPC::API::Qihu::Account::ids( auth )
     is_success( response )
     expect( response[:result].class ).to eq Array
  end

end