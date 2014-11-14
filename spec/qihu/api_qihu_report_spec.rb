describe ::PPC::API::Qihu::Report do
  auth = {}
  auth[:token] = $qihu_token
  auth[:accessToken] =  $qihu_accessToken

  it "can get keyword cost report" do
    param = { level:"account"}
    response = ::PPC::API::Qihu::Report::cost_report( auth , param)
  end

end
