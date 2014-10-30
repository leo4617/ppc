describe ::PPC::API::Baidu::Report do
  auth =  {}
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token

  test_plan_id = []

  # it 'can get real time report' do
  #   param = { type: 'plan', level:'plan',range:'plan',unit:'week',device:'all' }
  #   response = ::PPC::API::Baidu::Report::get_realtime( auth, param, 'data' )
  #   is_success( response )
  # end

  it 'can get professional report id' do
    param = { type: 'plan', level:'plan',range:'plan',unit:'week',device:'all' }
    response = ::PPC::API::Baidu::Report::get_id( auth, param )
    is_success( response )
    test_plan_id << response[:result]
  end

  it 'can get professional report status' do
    response = ::PPC::API::Baidu::Report::get_status( auth, test_plan_id[0] )
    is_success( response )
  end

  # it 'can get professional report download URL' do
  #   response = ::PPC::API::Baidu::Report::get_file_url( auth, test_plan_id[0] )
  #   is_success( response )
  # end

end
