describe ::PPC::API::Sogou::Report do
  auth = $sogou_auth

  param = {} 
  param[:type]   = 'keyword'
  param[:fields] =  %w(click impression)
  param[:endDate] = ( Time.now-2*3600*24).to_s[0..9].split('-').join
  param[:startDate] =( Time.now-27*3600*24).to_s[0..9].split('-').join

  test_report_id = 0
  it "can get report id" do
    response = ::PPC::API::Sogou::Report.get_id( auth, param )
    is_sucess( response )
    test_report_id = response[:result]
  end

  it "can get report state" do
    response = ::PPC::API::Sogou::Report.get_state( auth, test_report_id )
    is_success( response )
  end

  it "can get report url" do
    response = ::PPC::API::Sogou::Report.get_url( auth, test_report_id )
  end

  it "can download one report" do
  end

end

# describe "::PPC::API::Sogou::Report Operation interface " do
#   auth =  $sogou_auth 

#   subject{
#     ::PPC::API::Sogou::Report
#   }
#   # opetation report test
#   it 'can get report' do
#     endDate = ( Time.now-2*3600*24).to_s[0..9].split('-').join
#     startDate =( Time.now-27*3600*24).to_s[0..9].split('-').join

#     p "startDate:#{startDate}"
#     p "endDate:#{endDate}"

#     param = {startDate:startDate, endDate:endDate}
#     subject.query_report( auth, param, true )
#     subject.keyword_report( auth, param, true )
#     subject.creative_report( auth,param, true )
#   end

# end