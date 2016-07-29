ppc
===

    ppc for 'pay per click'. 
    This is a toolkit designed to provide consitent search engine account managing experience.

----------
#How to use it ?

### Create an objects:

    param = {
        se:         'baidu',        # baidu,qihu,sogou,sm
        username:   'username',
        password:   'password',
        token:      'token',
        id:         id,
    }

    # if it's a 奇虎 account
    # param[:cipherkey] = 'cipherkey'
    # param[:cipheriv]  = 'cipheriv'
    
    # if it's a 神马 account
    # param[:target] = 'username'
    
    account  = ::PPC::Operaion::Account.new(param)

    plan     = ::PPC::Operaion::Plan.new(param)
    group    = ::PPC::Operaion::Group.new(param)
    creative = ::PPC::Operaion::Creative.new(param)
    keyword  = ::PPC::Operaion::Keyword.new(param)
    
###Get objects info:

    # get info
    account.info[:result]
    plan.info[:result]
    group.info[:result]
    creative.info[:result]
    keyword.info[:result]
    
###Add keywords:
    keyword1 = { keyword: 'ppc1', group_id: 123, price:0.6, match_type:'wide'}
    keyword2 = { keyword: 'ppc2', group_id: 123, price:0.6, match_type:'phrase'}
    keyword3 = { keyword: 'ppc3', group_id: 123, price:0.6, match_type:'exact'}

    account.add_keyword( [keyword1, keyword2, keyword3] )
    plan.add_keyword( [keyword1, keyword2, keyword3] )
    group.add_keyword( [keyword1, keyword2, keyword3] )

###Delete keywords
    account.delete_keyword( [123, 234, 345] )
    plan.delete_keyword( [123, 234, 345] )
    adgroup.delete_keyword( [123, 234, 345] )
    
-----------------------------------------------
    
#API:

### Return values:
All mehtods return a hash:
    
    {
        succ: boolean,          # true if operation success else false
        failure: Array,         # failures info if operation false, else nil
        result: Array or hash   # Response body. Account service returns a hash, 
                                # others return Array of hash
    }
    

###API casting:
In each service class ::PPC::API::#{SE}::#{Service} there is a member map casting PPC API to Search engine Service API, 
For example:

    ::PPC::API::Baidu::Keyword.map  = [
            [:id,:keywordId],
            [:group_id,:adgroupId],
            [:keyword,:keyword],
            [:price,:price],
            [:pc_destination,:pcDestinationUrl],
            [:mobile_destination,:mobileDestinationUrl],
            [:match_type,:matchType],
            [:phrase_type,:phraseType],
            [:status,:status],
            [:pause,:pause]
         ]

ppc API keys are at the left side while search engine API keys are at the right side. 

For more info please have a look into files in /ppc/api/  
    

#LICENSE:
MIT
