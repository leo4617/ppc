module PPC
  module Baidu
    class Key
      include ::PPC::Baidu
      Service = 'Keyword'
      
      def self.add( auth, keywords )
        keywords = [ keywords ] unless keywords.is_a ? Array
        keywordtype = [ ]
    
        keywords.each{  | key_i |
          keywordtype << make_keywordtype( key_i ) 
        }

        body = {keywordtype: keywordtype}
        response = request( auth, Service, "addKeyword", body )['keywordTypes']
      end

      def self.update( auth, keywords )
        '''
        不知道以什么作为返回值好
        '''
        keywords = [ keywords ] unless keywords.is_a ? Array

        keywordtype =  []
        keywords.each{  |keyword|
          keywordtype << make_keywordtype( key_i ) 
        }

        body = { keywordTypes: keywordttype }
        
        request( auth, Service, "updateKeyword", body )
      end

      def self.delete( ids )
        """
        不知道返回什么好
        """
        ids = [ ids ] unless ids.class.is_a ? Array
        body = { :ids}
        request( auth, Service, 'deleteKeyword', body )
      end

      def self.active( auth, ids )
        """
        还没决定做不做，不知道输入使用long好还是用对象好。
        询问下一般用不用这个，一般怎么用。
        """
        ids = [ ids ] unless ids.is_a
        request( auth, Service, 'activateKeyword', ids)
      end

      def self.search_by_group_id( auth, group_ids, return_id = false )
        """
        getKeywordByGroupId
        @input: list of group id
        @output:  list of groupKeyword
        """
        group_ids = [ group_ids ] unless group_ids.is_a ? Array
        body = { adgroupIds: group_ids }
        request( auth, Service, "getKeywordByAdgroupId", body )
      end

      # 下面三个操作操作对象包括计划，组和关键字
      # 不知道放在这里合不合适
      def self.get_status( auth, ids, type )
        ids = [ ids ] unless ids.is_a ? Array
        type = case type
          when  'plan'      :     3 
          when  'group'   :     5
          when  'key'       :     11
          else{
              Exception.new( 'type must among: \'plan\',\'group\' and \'key\' ')            
          }
        end
        
        body = { ids: ids, type: type}
        request( auth, Service, 'getKeywordStatus', ids )['keywordStatus']
      end

      def self.get_quality( auth, ids, type )
        ids = [ ids ] unless ids.is_a ? Array

        type = case type
          when  'plan'      :     3 
          when  'group'   :     5
          when  'key'       :     11
          else{
              Exception.new( 'type must among: \'plan\',\'group\' and \'key\' ')            
          }
        end
        
        body = { ids: ids, type: type}
        request( auth, Service, 'getKeywordQuality', body )['keywordQuality']
      end

      def self.get_10quality( auth ,ids, type, device )
        ids = [ ids ] unless ids.is_a ? Array

        type = case type
          when  'plan'      :     3 
          when  'group'   :     5
          when  'key'       :     11
          else{
              Exception.new( 'type must among: \'plan\',\'group\' and \'key\' ')            
          }
        end
        
        device = case device
          when 'pc'          :    0
          when 'mobile'  :    1
          when 'both'      :    2
          else{
              Exception.new( 'device must among: \'pc\',\'mobile\' and \'both\' ')            
          }
        end

        body = { ids: ids, type: type, device:device }
        request( auth, Service, 'getKeyword10Quality', body )['keyword10Quality']
      end

      private
      def make_keywordtype( params )
        params = [ params ] unless params.is_a ? Array
        keywordttypes = []

        params.each{  |param| 
          keywordttype = {}
            
          keywordttype[:adgroupId]                     =    param[:id]                          if     param[:id]
          keywordttype[:campaignId]                   =    param[:plan_id]                if     param[:plan_id]  
          keywordttype[:adgroupName]              =    param[:name]                   if     param[:name]
          keywordttype[:maxPrice]                       =    param[:price]                     if    param[:price]
          keywordttype[:negativeWords]             =    param[:negative]               if    param[:negative]
          keywordttype[:exactNegativeWords]   =    param[:exact_negative]    if    param[:exact_negative]
          keywordttype[:matchType]                    =    param[:match_type]          if    param[:match_type] 
          keywordttype[:phraseType]                   =    param[:phrase_type]        if    param[:phrase_type]
          keywordttype[:pause]                             =    param[:pause]                    if    param[:pause]
        
          keywordttypes << keywordttype
        }
        return keywordttypes
      end

    end
  end
end