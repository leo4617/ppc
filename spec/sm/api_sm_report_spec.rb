describe ::PPC::API::Sm::Report do
  auth = $sm_auth
  date = "20150407"

  task_id = nil
  it 'can get professional report id' do
    param = { type: 'account', level:'account',range:'account',unit:'day', device:'all', startDate: date, endDate: date}
    response = ::PPC::API::Sm::Report::get_id( auth, param )
    task_id = response[:result]
    expect(task_id).not_to be_nil
  end

  it 'can get professional report status' do
    response = ::PPC::API::Sm::Report::get_state( auth, task_id )
    status = response[:result]
    expect(status).not_to be_nil
  end

  fileId = nil
  it 'can get professional report download fileId' do
    response = ::PPC::API::Sm::Report::get_fileId( auth, task_id )
    fileId = response[:result]
    expect(fileId).not_to be_nil
  end

  it 'can get the file' do
    response = ::PPC::API::Sm::Report::get_file(auth, fileId)
    warn response.force_encoding("GB2312").encode("UTF-8")
  end
end
