require 'awesome_print'
require 'net/http'
require 'net/https'
require 'httparty'
require 'json'
require 'savon'
require 'active_support'
require 'ppc/api/baidu'
require 'ppc/api/sogou'
require 'ppc/api/qihu'
require 'ppc/api/sm'

module PPC
  module API

    @map = nil
    @debug = false
    @match_types = nil

    def debug_on
      @debug = true
    end

    def debug_off
      @debug = false
    end

    def request_uri(param = {})
      raise 'you need build the uri'
    end

    def request_http_body(auth, params = {})
      {
        header: {
          username:   auth[:username],
          password:   auth[:password],
          token:      auth[:token],
          target:     auth[:target]
        },
        body: params
      }.to_json
    end

    def request_http_header(auth)
      {'Content-Type' => 'application/json; charset=UTF-8'}
    end

    def request(auth, service, method, params = {}, http_method = 'post')
      '''
        request should return whole http response including header
      '''
      uri = request_uri(service: service, method: method)
      http_body = request_http_body(auth, params)
      http_header = request_http_header(auth)

      # set request proxy
      if ENV["PROXY_HOST"]
        proxy_port = ENV["PROXY_PORT"] ? ENV["PROXY_PORT"].to_i : 80
        http = Net::HTTP.new(uri.host, 443, ENV["PROXY_HOST"], proxy_port)
      else
        http = Net::HTTP.new(uri.host, 443)
      end

      # 是否显示http通信输出
      http.set_debug_output( $stdout ) if @debug
      http.use_ssl = true
      if http_method == 'delete'
        req = Net::HTTP::Delete.new(uri.path, http_header)
        req.body = http_body
        response = http.request req
      else
        response = http.post(uri.path, http_body, http_header)
      end
      begin JSON.parse(response.body) rescue response.body end
    end

    def process( response, key, &func)
      '''
        Process Http response. If operation successes, return value of given keys.
        You can process the result using function &func, or do nothing by passing 
        block {|x|x}
        =========================== 
        @Output: resultType{ desc: boolean, failure: Array,  result: Array }

        failure is the failures part of response\'s header
        result is the processed response body.
      '''
      raise 'you need build the response result'
    end

    def is_no_quota(failure, code)
      return false if failure.nil?
      failure = [failure].flatten
      return false if failure.size.zero?
      return failure[0]["code"] == code
    end

    def make_type( params, maps = @map)
      '''
        tranfesr ppc api to search engine api
        @ input
          params : list of hash complying with PPC gem api  
          map : list of pairs(lists) of symbol complying with following api
          map = [ 
                        [ ppc_key, api_key ],
                        [ ppc_key, api_key ],
                        [ ppc_key, api_key ],
                                        ...
                        ]
          Ex: 
          baidu_group_map = [ [ :id, :adgroupId],
                                                  [ :price, :maxPrice],
                                                          ...                 ]
        ===================
        @ output:
          types : list of hash that complying with search engine api
      '''
      [ params ].flatten.map do |item| 
        item.select!{|key| maps.any?{|m| m[0] == key} }
        maps.each{|key_new, key_old| item[key_old] = (key_new == :match_type ? @match_types[item.delete(key_new)] : item.delete(key_new)) if item[key_new] }
        item
      end
    end

    def reverse_type( types, maps = @map )
      '''
        transfer search engine api to ppc api
        @ input
          types : list of hash that complying with search engine api
          map : list of pairs(lists) of symbol, for more details please 
                      read docs of make_type()
        ===================
        @ output:
          params : list of hash complying with PPC gem api  
      '''
      [ types ].flatten.map do |item| 
        maps.each{|key_new, key_old| 
          value = item.delete(key_old.to_s) || item.delete(key_old)
          value = value[/pause/] ? true : false if value && key_new == :pause && key_old == :status
          item[key_new] = (key_new == :match_type ? @match_types[value] : value) if value
        }
        item
      end
    end
  end
end
