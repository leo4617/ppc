describe ::PPC::Baidu::Account do
  subject{::PPC::Baidu::Account.new(
            debug:true,
            username:$baidu_username,
            password:$baidu_password,
            token:$baidu_token
  )}

  # it "prints all info" do
  #   expect(subject.info.keys).to eq ["userid", "balance", "cost", "payment", "budgetType", "budget", "regionTarget", "excludeIp", "openDomains", "regDomain", "budgetOfflineTime", "weeklyBudget", "userStat", "isDynamicCreative", "dynamicCreativeParam", "opt"]
  # end

  # it "prints all updated info" do
  #   info = { budget_type: 1, budget: 3000 }
  #   response = subject.update( info )

  #   expect(response.keys).to eq ["userid", "balance", "cost", "payment", "budgetType", "budget", "regionTarget", "excludeIp", "openDomains", "regDomain", "budgetOfflineTime", "weeklyBudget", "userStat", "isDynamicCreative", "dynamicCreativeParam", "opt"]
  #   expect(response["budgetType"]).to eq 1
  #   expect(response["budget"]).to eq 3000
  # end


  # it "can get plans by one id" do
  #   id = subject.plan_ids().first
  #   response = subject.get_plan_by_id(id)
  #   expect(response.class).to be Hash
  #   expect(response['campaignId']).to be id
  #   expect(response).to have_key 'campaignName'
  # end

  # it "can add a plan" do
  #   response = subject.add_plan({name:"测试计划#{Time.now.to_i}"})
  #   expect(response).to have_key 'campaignId'
  #   expect(response['campaignId']).to be > 0
  # end

  # it "can add two plans" do
  #   plan1 = {name:"测试计划1#{Time.now.to_i}"}
  #   plan2 = {name:"测试计划2#{Time.now.to_i}"}

  #   response = subject.add_plan([plan1,plan2])
  #   expect(response.class).to be Array
  #   expect(response.first['campaignId']).to be > 0
  #   expect(response[1]['campaignId']).to be > 0
  # end


  it "can update one plan" do
    random_plan_id = subject.plan_ids.first
    new_name = "测试计划#{Time.now.to_i}"
    response = subject.update_plan_by_id(random_plan_id,{campaignName: new_name})
    expect(response.class).to be Array
    expect(response.first.class).to be Hash
    expect(response.first['campaignName']).to eq new_name
  end

  it "can update two plans" do
    random_plan_id1 = subject.plan_ids[0]
    random_plan_id2 = subject.plan_ids[1]

    new_name1 = "测试计划1_#{Time.now.to_i}"
    new_name2 = "测试计划2_#{Time.now.to_i}"

    plans = []
    plans << {campaignId: random_plan_id1,campaignName: new_name1}
    plans << {campaignId: random_plan_id2,campaignName: new_name2}
    response = subject.update_plans(plans)
    expect(response.class).to be Array
    expect(response.first.class).to be Hash
    expect(response[0]['campaignName']).to eq new_name1
    expect(response[1]['campaignName']).to eq new_name2
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
