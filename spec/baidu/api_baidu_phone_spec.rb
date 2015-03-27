# -*- coding:utf-8 -*-
describe ::PPC::API::Baidu::Phone do
  auth = $baidu_auth

  ::PPC::API::Baidu::debug_off
  test_group_id = ::PPC::API::Baidu::Group::ids( auth )[:result][0][:group_ids][0]
  test_phone_id = 0
  ::PPC::API::Baidu::debug_on

  it 'can search id by group id' do
    response = ::PPC::API::Baidu::Phone::search_id_by_group_id( auth, test_group_id, 0 )
    test_phone_id =  response[:result][0][:phone_ids][0]
    is_success( response )
  end

  it 'can update' do 
    response = ::PPC::API::Baidu::Phone::update( auth, {id: test_phone_id,pause: true})
    p response
    is_success( response )
  end

end
