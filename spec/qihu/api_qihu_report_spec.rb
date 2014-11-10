describe ::PPC::API::Qihu::Report do
  auth = {}
  auth[:token] = $qihu_token
  auth[:accessToken] =  $qihu_accessToken

  it "can get keyword cost report" do
    param = { level:"group"}
    response = ::PPC::API::Qihu::Report::get_keyword_report( auth , param)
  end

end
