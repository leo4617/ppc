describe ::PPC::API::Baidu::Report do
  auth =  {}
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token

  Test_report_id = []

  it 'can get real time report' do
    param = { type: 'plan', level:'plan',range:'plan',unit:'week',device:'all' }
    response = ::PPC::API::Baidu::Report::get_realtime( auth, param, 'data', true)
    is_successed( response )
  end

  it 'can get professional report id' do
    param = { type: 'plan', level:'plan',range:'plan',unit:'week',device:'all' }
    response = ::PPC::API::Baidu::Report::get_id( auth, param, true)
    is_successed( response )
    Test_report_id << response['body']['reportId']
  end

  it 'can get professional report status' do
    response = ::PPC::API::Baidu::Report::get_status( auth, Test_report_id[0], true)
    is_successed( response )
  end

  it 'can get professional report download URL' do
    response = ::PPC::API::Baidu::Report::get_file_url( auth, Test_report_id[0], true)
    is_successed( response )
  end

end
