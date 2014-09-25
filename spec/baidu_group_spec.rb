describe ::PPC::Baidu::Group do
  subject{::PPC::Baidu::Group.new(
            debug:true,
            username:$baidu_username,
            password:$baidu_password,
            token:$baidu_token
  )}

  it " test get all group info " do
    response = subject.all()
    response.each{  |campaign|
      expect( campaign.keys ).to eq ["campaignId", "adgroupIds"] 
    }
  end

  it " test add group " do
    response = subject.add( {plan_id: 8537330, name:"test_group",maxprice: 500 })
    response.each{  |adgrouptype|
      expact(adgrouptype["adgroupId"].class ).to be != nil 
    }
  end

  it " test updat group " do
    params = [ {group_id: 718157905, name:"testgroup", maxprice: 3030},
                        {group_id: 719515376, name:"testgroup1", maxprice: 3030} ]
    response = subject.update( params )
    response.each{  | group |
      expect(group["maxPrice"]).to eq 3030
    }
  end

  it " test delete  group " do
    ids = [718157905, 719515376, 719515373]
    response = subject.delete( ids, test_model = true )
    expect(response["header"]["desc"]).to eq "success"
  end

  it "test search group by campaignId" do
    ids = [ 8537330 ]
    response = subject.search_by_campaignID( ids , with_header = true)
    expect( response["header"]["desc"] ).to eq "success"
  end

  it "test search group by group id" do
    ids = [ 161474486, 161474483 ]
    response = subject.search_by_campaignID( ids , with_header = true)
    expect( response["header"]["desc"] ).to eq "success"
  end

end
