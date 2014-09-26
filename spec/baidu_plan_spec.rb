describe ::PPC::Baidu::Plan do
  subject{::PPC::Baidu::Plan.new(
            debug:true,
            username:$baidu_username,
            password:$baidu_password,
            token:$baidu_token
  )}

  it "can get all plans" do
    response = subject.plans
    expect(response.class).to be Array
    expect(response.first.class).to be Hash
    expect(response.first['campaignId']).to be > 0
  end



  it "can get all plan ids" do
    response = subject.ids()
    expect(response.class).to be Array
  end


  it "can delete one plan by the id" do
    ids = subject.ids()
    response = subject.delete(ids.first)
    expect(response).to be true
  end

  it "can delete two plans by the ids" do
    ids = subject.ids()
    pending if ids.size < 2
    response = subject.delete(ids[0..1])
    expect(response).to be true
  end
  # it "could download all plan" do
  #   result = subject.all
  #   if result
  #     expect(result.keys).to include :account_file_path
  #   else
  #     expect(subject.code).to eq '901162'
  #   end
  # end
  it "enables one plan by id" do
    id = subject.ids().first

    response = subject.enable(id)
    expect(response.class).to be Array
    expect(response.first.class).to be Hash
    expect(response.first['pause']).to be false
  end

  it "enables two plans by ids" do
    id1 = subject.ids()[0]
    id2 = subject.ids()[1]

    response = subject.enable([id1,id2])
    expect(response.class).to be Array
    expect(response.first.class).to be Hash
    expect(response[0]['pause']).to be false
    expect(response[1]['pause']).to be false
  end

  it "pauses one plan by id" do
    id = subject.ids().first

    response = subject.pause(id)
    expect(response.class).to be Array
    expect(response.first.class).to be Hash
    expect(response.first['pause']).to be true
  end

  it "pauses two plans by ids" do
    id1 = subject.ids()[0]
    id2 = subject.ids()[1]
    response = subject.pause([id1,id2])
    expect(response.class).to be Array
    expect(response.first.class).to be Hash
    expect(response[0]['pause']).to be true
    expect(response[1]['pause']).to be true
  end
end
