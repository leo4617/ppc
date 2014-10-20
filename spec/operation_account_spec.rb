describe ::PPC::Operation::Account do

  auth =  {}
  auth[:se] = 'Baidu'
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token

  account = ::PPC::Operation::Account.new( auth )

  it "can get account info" do
    p account.info
  end
  
end
