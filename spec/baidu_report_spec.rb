describe ::PPC::Baidu::Report do
  subject{
    ::PPC::Baidu::Report.new(
      debug:true,
      username:'',
      password:'',
      token:'')
  }
  it "could get report_id" do
    file_id = subject.file_id_of_query
    expect(file_id.size).to eq 32
    times = 0
    state = 0
    loop do
      state = subject.state(file_id)
      break if state == 3 or times >= 3
      times += 1
      sleep 5
    end
    expect(state).to eq 3
    path = subject.path(file_id)
    expect(path).to begin_with? 'https://'
  end
end
