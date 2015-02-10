# -*- coding:utf-8 -*-
describe ::PPC::API::Sogou::Keyword do
  '''
  sogou的关键词服务在add的时候需要审核因此不能一次通过，
  会出现keyword is pending的error.不过手动测试方法没问题了。
  '''
  auth = $sogou_auth

  ::PPC::API::Sogou.debug_off
  test_group_id = ::PPC::API::Sogou::Group::ids( auth )[:result][0][:group_ids][0]
  test_keyword_id = []
  #::PPC::API::Sogou.debug_on

  it 'can search keyword by group id' do
    response = ::PPC::API::Sogou::Keyword::search_by_group_id( auth, test_group_id )
    is_success( response )
    expect(response[:result]).not_to be_nil
  end

  it 'can add keyword' do
    keyword = { group_id: test_group_id, keyword: 'testkeyword123', match_type:'exact' }
    response = ::PPC::API::Sogou::Keyword::add( auth, keyword )
    is_success( response )
    expect(response[:result]).not_to be_nil
    test_keyword_id << response[:result][0][:id]
  end

  it 'can get status' do
    response = ::PPC::API::Sogou::Keyword::status( auth, test_keyword_id )
    is_success(response)
    expect(response[:result][0].keys).to eq [:id,:status]
    expect(response[:result]).not_to be_nil
  end

  it 'can get quality' do 
    response = ::PPC::API::Sogou::Keyword::quality( auth, test_keyword_id)
    is_success(response)
    expect(response[:result][0].keys).to eq [:id,:quality]
    expect(response[:result]).not_to be_nil
  end

  it 'can update keyword' do
    update = { id: test_keyword_id[0], pause: true} 
    response = ::PPC::API::Sogou::Keyword::update( auth, update )
    is_success( response )
    expect(response[:result]).not_to be_nil
  end

  it 'can delete keyword' do
    response = ::PPC::API::Sogou::Keyword::delete( auth, test_keyword_id )
    is_success( response )
  end

end
