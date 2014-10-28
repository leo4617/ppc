ppc
===

    ppc for 'pay per click'. This is a toolkit designed to provide consitent search engine account managing experience.

----------
##How to use it ?

### Create an account:
    param = {}
    param[:se] = 'baidu'
    param[:username] = 'userbame'
    param[:password] = 'password'
    param[:token] = 'token'
    
    account = ::PPC::Operaion::account.new(param)

###Add keywords:
    keyword1 = { keyword: 'ppc', group_id: 123, price:0.6, match_type:'wide'}
    keyword2 = { keyword: 'test_ppc', group_id: 123, price:0.6, match_type:'exact'}
    account.add_keyword( [keyword1, keyword2] )
    
###Another way to add keyword:
    keyword1 = { keyword: 'ppc', price:0.6, match_type:'wide'}
    keyword2 = { keyword: 'test_ppc', price:0.6, match_type:'exact'}
    # get method return an Array
    group = account.get_group( $group_id )[0]
    group.add_keyword( [ keyword1, keyword2 ] ) 
    


More info is to be added. If you want to have a try, fork and have a look into 'ppc/operation' in oop branch