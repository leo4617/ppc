describe ::PPC::API::Sm::Plan do

  auth = $sm_auth 
  test_plan_id = 0
  plan_service = ::PPC::API::Sm::Plan

  it "can get all plans" do
    response = plan_service.all( auth )
    p response
    expect(response[:succ]).to be true
  end
  it "can get all plan ids" do 
    response = plan_service.ids( auth )
    p response
    expect(response[:succ]).to be true
    expect(response[:result].is_a? Array).to be true
  end
  it "can add a new plan and get its id" do
    response = plan_service.add(auth, {name: 'test_2', pause: true})
    p response
    expect(response[:succ]).to be true
    new_plan = response[:result][0]
    expect(new_plan.class).to eql Hash
    expect(new_plan[:id]).to be > 0 
    test_plan_id = new_plan[:id]
  end
  it "can get a plan by id" do
    response = plan_service.get(auth, test_plan_id)
    p response
    plan = response[:result][0]
    expect(plan.class).to eql Hash
    expect(plan[:pause]).to be true
  end
  it "can delete a plan by id" do 
    response = plan_service.delete(auth, test_plan_id)
    p response
    expect(response[:succ]).to be true
  end
end 
