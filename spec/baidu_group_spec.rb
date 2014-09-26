describe ::PPC::Baidu::Group do
  subject{::PPC::Baidu::Group.new(
            debug:true,
            username:$baidu_username,
            password:$baidu_password,
            token:$baidu_token
  )}

  Test_group1 = {plan_id: 8537330, name:"test_group1",maxprice: 500 }
  Test_group2 = {plan_id: 8537330, name:"test_group2",maxprice: 500 }
  Test_groups = [ Test_group1, Test_group2 ]
  $test_group_ids = []
  $test_plan_ids = []

  it " can get all group info " do
    response = subject.all()
    response.each{  |campaign|
      expect( campaign.keys ).to eq ["campaignId", "adgroupIds"] 
      $test_plan_ids << campaign["campaignId"]
    }
  end

  it " can add group " do
    response = subject.add( Test_groups, true )
    expect( response['header']['desc'] ).to eq 'success'

    # store test_group _id s
    response = response['body']['adgroupTypes']
    response.each{  |group|
     $test_group_ids << group[ 'adgroupId' ]
    }
  end

  it " can update group " do
    updates = [ { group_id: $test_group_ids[0], maxprice:550 } , 
                      { group_id: $test_group_ids[1], maxprice:550 } ]
    response = subject.update( updates, true )
    expect( response['header']['desc'] ).to eq 'success'
  end

  it "can search group by group id" do
    response = subject.search_by_groupid( $test_group_ids ,  true)
    expect( response["header"]["desc"] ).to eq "success"
  end

  it " can delete group " do
    response = subject.delete( $test_group_ids )
    expect( response ).to eq "success"
  end

  it "can search group by planId" do
    response = subject.search_by_planid( $test_plan_ids , true)
    expect( response["header"]["desc"] ).to eq "success"
  end
  
end
