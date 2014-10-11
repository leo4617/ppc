describe ::PPC::Baidu::Bulk do
  subject{::PPC::Baidu::Bulk.new(
            debug:true,
            username:'',
            password:'',
            token:'')
          }
  it "could get file_id_of_all" do
    begin
      result = subject.file_id_of_all
    rescue
      expect(subject.code).to eq '901162'
    end

    if result.nil?
      expect(subject.code).to eq '901162'
    else
      expect(result.size).to eq 32
    end
  end
end
