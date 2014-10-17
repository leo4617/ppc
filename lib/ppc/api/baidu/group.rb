# -*- coding:utf-8  -*-
module PPC
  module API
    class Baidu
      class Group< Baidu
        Service = 'Adgroup'

        @map =[
                        [:plan_id, :campaignId],
                        [:id, :adgroupId],
                        [:name, :adgroupName],
                        [:price, :maxPrice],
                        [:negative, :negativeWords],
                        [:exact_negative, :exactNegativeWords],
                        [:pause, :pause],
                        [:status, :status],
                        [:reserved, :reserved]
                      ]

        # introduce request to this namespace
        def self.request(auth, service, method, params = {} )
          ::PPC::API::Baidu::request(auth, service, method, params )
        end

        def self.ids(auth, test = false )
          """
          @return : Array of campaignAdgroupIds
          """
          response = request( auth, Service , "getAllAdgroupId" )
          process( response, 'campaignAdgroupIds', test ){ |x| x }
        end

        def self.get( auth, ids, test = false )
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids }
          response = request(auth, Service, "getAdgroupByAdgroupId",body )
          process( response, 'adgroupTypes', test ){ |x| reverse_type(x) }
        end

        def self.add( auth, groups, test = false )
          """
          @ input : one or list of AdgroupType
          @ output : list of AdgroupType
          """
          adgrouptypes = make_type( groups )

          body = {adgroupTypes:  adgrouptypes }
          
          response = request( auth, Service, "addAdgroup", body  )
          process( response, 'adgroupTypes', test ){ |x| reverse_type(x) }
        end

        def self.update( auth, groups, test = false )
          """
          @ input : one or list of AdgroupType
          @ output : list of AdgroupType
          """
          adgrouptypes = make_type( groups )
          body = {adgroupTypes: adgrouptypes}
          
          response = request( auth, Service, "updateAdgroup",body )
          process( response, 'adgroupTypes', test ){ |x| reverse_type(x) }
        end

        def self.delete( auth, ids, test = false )
          """
          奇怪的返回模式，没有任何信息
          """
          ids = [ ids ] unless ids.is_a? Array
          body = { adgroupIds: ids }
          response = request( auth, Service,"deleteAdgroup", body )
          
          # 只能将process方法修改下放到这里
          if test 
            return response 
          elsif response['header']['desc'] == 'success'
            return ture
          else
            result = {}
            result[:desc] = response['header']['desc']
            result[:faliure] = response['header']['failures']
            result[:value] = ''
            return result
          end

        end

        def self.search_by_plan_id( auth, ids, test = false )
          ids = [ ids ] unless ids.class == Array
          body = { campaignIds: ids }
          response = request( auth, Service ,"getAdgroupByCampaignId",  body )
          process( response, 'campaignAdgroups', test ){ |x| x }
        end

        # private
        # def self.make_adgrouptype( params )
        #     params = [ params ] unless params.is_a? Array
        #     adgrouptypes = []

        #     params.each{  | param | 
        #       adgrouptype = {}

        #       adgrouptype[:campaignId]                  =   param[:plan_id]                 if    param[:plan_id] 
        #       adgrouptype[:adgroupId]                    =   param[:id]                           if    param[:id] 
        #       adgrouptype[:adgroupName]             =   param[:name]                    if    param[:name] 
        #       adgrouptype[:maxPrice]                      =   param[:price]                     if    param[:price] 
        #       adgrouptype[:negativeWords]            =   param[:negative]               if    param[:negative]
        #       adgrouptype[:exactNegativeWords]  =   param[:exact_negative]    if    param[:exact_negative] 
        #       adgrouptype[:pause]                            =   param[:pause]                    if    param[:pause] 
        #       adgrouptype[:status]                            =   param[:status]                    if    param[:status] 
        #       adgrouptype[:reserved]                       =   param[:reserved]               if    param[:reserved] 
              
        #       adgrouptypes << adgrouptype
        #     }
        #     return adgrouptypes
        # end #make_adgrouptype

      end # class group
    end # class baidu
  end # API
end # module