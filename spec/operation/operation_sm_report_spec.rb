describe "::PPC::API::Sm::Report Operation interface" do
  auth =  $sm_auth 

  subject{
    ::PPC::API::Sm::Report
  }
  # opetation report test
  it 'can get report' do
    endDate = "20150407"
    startDate = "20150407"

    p "startDate:#{startDate}"
    p "endDate:#{endDate}"

    param = {startDate:startDate, endDate:endDate}
    p subject.query_report( auth, param, true )
    p subject.keyword_report( auth, param, true )
    p subject.creative_report( auth,param, true )
  end

end
