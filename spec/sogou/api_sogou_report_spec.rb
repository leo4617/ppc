describe ::PPC::API::Sogou::Report do
  auth = $sogou_auth

  param = {} 
  param[:type]   = 'keyword'
  param[:fields] =  %w(impression click cpc cost ctr)
  param[:endDate] = ( Time.now-2*3600*24).to_s[0..9].split('-').join
  param[:startDate] =( Time.now-7*3600*24).to_s[0..9].split('-').join


  test_report_id = []
  it "can get report id" do
    response = ::PPC::API::Sogou::Report.get_id( auth, param )
    is_success( response )
    test_report_id << response[:result]
  end

  it "can get report state" do
    response = ::PPC::API::Sogou::Report.get_state( auth, test_report_id[0] )
    is_success( response )
  end

  it "can get report url" do
    response = ::PPC::API::Sogou::Report.get_url( auth, test_report_id[0] )
    is_success( response )
  end

  it "can download one report" do
    report = ::PPC::API::Sogou::Report.download_report( auth, param )
  end

end

describe "::PPC::API::Sogou::Report Operation interface " do
  auth =  $sogou_auth 

  subject{
    ::PPC::API::Sogou::Report
  }
  # opetation report test
  it 'can get report' do
    endDate = ( Time.now-2*3600*24).to_s[0..9].split('-').join
    startDate =( Time.now-27*3600*24).to_s[0..9].split('-').join

    param = {startDate:startDate, endDate:endDate}
    subject.query_report( auth, param )
    subject.keyword_report( auth, param )
    subject.creative_report( auth,param )
  end

end