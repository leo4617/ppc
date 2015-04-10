describe ::PPC::API::Sm::Creative do 
  auth = $sm_auth
  creative_service = ::PPC::API::Sm::Creative
  test_creative_id = 0
  test_plan_id = ::PPC::API::Sm::Plan.ids(auth)[:result][0]
  test_group_id = ::PPC::API::Sm::Group.search_id_by_plan_id(auth, test_plan_id)[:result][0][:group_ids][0]

  it "can get ids by group id " do
    response = creative_service.search_id_by_group_id(auth, test_group_id)
    p response
    expect(response[:succ]).to be true
    expect(response[:result][0][:group_id] == test_group_id).to be true
    expect(response[:result][0][:creative_ids].is_a? Array).to be true
  end

  it "can get by group id" do 
    response = creative_service.search_by_group_id(auth, test_group_id)
    p response
    expect(response[:succ]).to be true
    expect(response[:result][0][:group_id] == test_group_id).to be true
    expect(response[:result][0][:creatives].is_a? Array).to be true
  end

  it "can add a new creative" do
    response = creative_service.add(auth, {group_id: test_group_id, title: 'test title', description1: 'test desc1', mobile_destination: 'http://m.elong.com', mobile_display: 'm.elong.com', pause: true})
    p response
    expect(response[:succ]).to be true
    expect(response[:result][0][:id]).to be > 0
    test_creative_id = response[:result][0][:id]
  end

  it "can update a creative" do
    response = creative_service.update(auth, {id: test_creative_id, title: 'test tttt', description1: 'xxxxxxxxxxx', mobile_destination: 'http://m.elong.com'})
    p response
    expect(response[:succ]).to be true
  end

  it "can get a creative by id" do
    response = creative_service.get(auth, test_creative_id)
    p response
    expect(response[:succ]).to be true
    expect(response[:result][0][:title]).to eql 'test tttt'
    expect(response[:result][0][:pause]).to be true
  end

  it "can delete a creative by id" do 
    response = creative_service.delete(auth, test_creative_id)
    p response
    expect(response[:succ]).to be true
    expect(response[:result]).to eql 0
  end
end
