  auth =  {}
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token
  auth[:se] = 'baidu'

describe ::PPC::Operation::Account do
  subject{
    ::PPC::Operation::Account.new( auth )
  }
  # opetation report test
  it 'can get report' do
    endDate = Time.now.utc.iso8601
    startDate =( Time.now-30*3600*24).utc.iso8601
    pa = {startDate:startDate, endDate:endDate}
    subject.query_report( pa, true )
    subject.keyword_report( pa, true )
    subject.creative_report( pa, true )
  end
end
