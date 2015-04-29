describe ::PPC::API::Sm::Group do 
  auth = $sm_auth
  group_service = ::PPC::API::Sm::Group
  test_group_id = 0
  test_plan_id = 0

  it "can get all group ids" do 
    response = group_service.ids(auth)
    p response
    expect(response[:succ]).to be true
    plan_group_ids_0 = response[:result][0]
    plan_id = plan_group_ids_0[:plan_id]
    expect(plan_id).to be > 0
    test_plan_id = plan_id
    group_ids = plan_group_ids_0[:group_ids]
    expect(group_ids.is_a? Array).to be true
  end

  it "can get ids by plan id" do
    response = group_service.search_id_by_plan_id(auth, test_plan_id)
    p response
    expect(response[:succ]).to be true
    plan_group_ids_0 = response[:result][0]
    plan_id = plan_group_ids_0[:plan_id]
    expect(plan_id == test_plan_id).to be true
    group_ids = plan_group_ids_0[:group_ids]
    expect(group_ids.is_a? Array).to be true
  end

  it "can get groups by plan id" do 
    response = group_service.search_by_plan_id(auth, test_plan_id)
    p response
    expect(response[:succ]).to be true
    plan_groups_0 = response[:result][0]
    plan_id = plan_groups_0[:plan_id]
    expect(plan_id == test_plan_id).to be true
    groups = plan_groups_0[:groups]
    expect(groups.is_a? Array).to be true
    expect(groups[0][:id]).to be > 0
  end

  it "can add a new group" do 
    # price 不能为空 os 不能为空
    response = group_service.add(auth, {plan_id: test_plan_id, name: 'test_x', pause: true, price: 1.0, os: 7})
    p response
    expect(response[:succ]).to be true
    group = response[:result][0]
    expect(group[:id]).to be > 0
    expect(group[:pause]).to be true
    test_group_id = group[:id]
  end

  it "can update a group" do
    response = group_service.update(auth, {id: test_group_id, pause: false})
    p response
    expect(response[:succ]).to be true
    group = response[:result][0]
    expect(group[:pause]).to be false
  end

  it "can get a group by id" do 
    response = group_service.get(auth, test_group_id)
    p response
    expect(response[:succ]).to be true
    group = response[:result][0]
    expect(group[:name]).to eql 'test_x'
  end

  it "can delete a group by id" do
    response = group_service.delete(auth, test_group_id)
    p response
    expect(response[:succ]).to be true
    expect(response[:result]).to eql 0
  end
end
