describe ::PPC::Operation::Account do

  auth =  {}
  auth[:se] = 'Baidu'
  auth[:username] = $baidu_username
  auth[:password] = $baidu_password 
  auth[:token] = $baidu_token

  account = ::PPC::Operation::Account.new( auth )

  # it "can get account info" do
  #   info = account.info
  #   expect( info.keys ).to eq [:id, :balance, :cost, :payment, 
  #                                                 :budget_type, :budget, :region, 
  #                                                 :exclude_ip, :open_domains, 
  #                                                 :reg_domain, :offline_time, 
  #                                                 :weekly_budget]
    
  # end

  # it "can updata account" do
  #   """
  #   account.update, 尽管desc返回值为success，
  #   但是在使用budget关键字实验的条件下
  #   真实数据并未被更改
  #   """
  #   info = account.update( { budget:2500 } )
  # end

  # it "can get all plan" do
  #   account.plans()
  # end

  # it "can get all plan ids" do
  #   account.plan_ids()
  # end

  # it "can get plan" do
  #   account.get_plan([19749949, 19749940, 19749937])
  # end

  it "can add plan "

end
