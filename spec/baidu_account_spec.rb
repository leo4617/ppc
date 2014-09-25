describe ::PPC::Baidu::Account do
  subject{::PPC::Baidu::Account.new(
            debug:true,
            username:$baidu_username,
            password:$baidu_password,
            token:$baidu_token
  )}

  it "prints all info" do
    expect(subject.info.keys).to eq ["userid", "balance", "cost", "payment", "budgetType", "budget", "regionTarget", "excludeIp", "openDomains", "regDomain", "budgetOfflineTime", "weeklyBudget", "userStat", "isDynamicCreative", "dynamicCreativeParam", "opt"]
  end

  it "prints all updated info" do
    info = { budget_type: 1, budget: 3000 }
    response = subject.update( info )

    expect(response.keys).to eq ["userid", "balance", "cost", "payment", "budgetType", "budget", "regionTarget", "excludeIp", "openDomains", "regDomain", "budgetOfflineTime", "weeklyBudget", "userStat", "isDynamicCreative", "dynamicCreativeParam", "opt"]
    expect(response["budgetType"]).to eq 1
    expect(response["budget"]).to eq 3000
  end

  # it "could download all plan" do
  #   result = subject.all
  #   if result
  #     expect(result.keys).to include :account_file_path
  #   else
  #     expect(subject.code).to eq '901162'
  #   end
  # end
end
