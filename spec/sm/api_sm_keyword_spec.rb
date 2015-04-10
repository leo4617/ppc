describe ::PPC::API::Sm::Keyword do
  auth = $sm_auth
  keyword_service = ::PPC::API::Sm::Keyword
  test_keyword_id = 0
  test_plan_id = ::PPC::API::Sm::Plan.ids(auth)[:result][0]
  test_group_id = ::PPC::API::Sm::Group.search_id_by_plan_id(auth, test_plan_id)[:result][0][:group_ids][0]
  it "can get ids by group id" do 
    response = keyword_service.search_id_by_group_id(auth, test_group_id)
    p response
    expect(response[:succ]).to be true
    group_id = response[:result][0][:group_id]
    expect(group_id == test_group_id).to be true
    expect(response[:result][0][:keyword_ids].is_a? Array).to be true
  end

  it "can get by group id" do 
    response = keyword_service.search_by_group_id(auth, test_group_id)
    p response
    expect(response[:succ]).to be true
    expect(response[:succ]).to be true
    group_id = response[:result][0][:group_id]
    expect(group_id == test_group_id).to be true
    expect(response[:result][0][:keywords].is_a? Array).to be true
  end

  it "can add a new keyword" do 
    response = keyword_service.add(auth, {group_id: test_group_id, keyword: 'testtest1', mobile_destination: 'http://m.elong.com', match_type: 'exact', pause: true, price: 1.2})
    p response
    expect(response[:succ]).to be true
    expect(response[:succ]).to be true
    expect(response[:result][0][:id]).to be > 0
    test_keyword_id = response[:result][0][:id]
  end

  it "can update a keyword" do 
    response = keyword_service.update(auth, {id: test_keyword_id, price: 2})
    p response
    expect(response[:succ]).to be true
    expect(response[:succ]).to be true
    expect(response[:result][0][:price] == 2).to be true
  end

  it "can get by id" do 
    response = keyword_service.get(auth, test_keyword_id)
    p response
    expect(response[:succ]).to be true
    expect(response[:succ]).to be true
    expect(response[:result][0][:keyword]).to eql 'testtest1'
  end

  it "can delete by id" do 
    response = keyword_service.delete(auth, test_keyword_id)
    p response
    expect(response[:succ]).to be true
    expect(response[:succ]).to be true
    expect(response[:result]).to eql 0
  end

end
