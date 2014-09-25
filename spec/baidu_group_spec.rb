describe ::PPC::Baidu::Group do
  subject{::PPC::Baidu::Group.new(
            debug:true,
            username:$baidu_username,
            password:$baidu_password,
            token:$baidu_token
  )}

  it "print all group info" do
    response = subject.all()
    p response
  end
end
