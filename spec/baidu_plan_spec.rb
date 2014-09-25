describe ::PPC::Baidu::Plan do
  subject{::PPC::Baidu::Plan.new(
            debug:true,
            username:$baidu_username,
            password:$baidu_password,
            token:$baidu_token
  )}
  it "can add a plan" do
    response = subject.add({name:"测试计划#{Time.now.to_i}"})
    expect(response).to have_key 'campaignId'
    expect(response['campaignId']).to be > 0
  end

  it "can get all plan ids" do
    response = subject.ids()
    expect(response.class).to be Array
  end

  it "can delete one plan by the id" do
    ids = subject.ids()
    response = subject.delete(ids.first)
    expect(response)
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
