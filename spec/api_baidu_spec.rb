require 'json'
require 'ppc/api/baidu/account'
describe ::PPC::API::Baidu do

  fake_response = "{\"header\":{\"desc\":\"success\",\"failures\":[],\"oprs\":1,\"oprtime\":0,
                                 \"quota\":2,\"rquota\":34047,\"status\":0},\"body\":{
                                  \"accountInfoType\":{\"userid\":5707012,\"balance\":0.0,\"cost\":0.0,
                                  \"payment\":0.0,\"budgetType\":1,\"budget\":3000.0,\"regionTarget\":[9999999],
                                  \"excludeIp\":[],\"openDomains\":[\"elong.com\"],\"regDomain\":\"elong.com\",
                                  \"budgetOfflineTime\":[],\"weeklyBudget\":[],\"userStat\":null,\"isDynamicCreative\":null,
                                    \"dynamicCreativeParam\":null,\"opt\":null}}}"

  response = JSON.parse fake_response

  Expected_success_result = [:id, :balance, :cost, :payment, 
                                                :budget_type, :budget, :region, :exclude_ip, 
                                                :open_domains, :reg_domain, :offline_time, 
                                                :weekly_budget ]

  Expected_failure_result = ["code", "message", "position", "content"] 

  it 'can process response' do
    response = ::PPC::API::Baidu::process( response, 'accountInfoType' ){|x| ::PPC::API::Baidu::Account::reverse_info_type(x)}
    expect( response.keys ).to eq Expected_success_result
  end

end
