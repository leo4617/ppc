# -*- coding:utf-8 -*-
require 'httpparty'


def request( auth, service, method, params )
  url = "https://api.e.360.cn/#{service}/#{method}"
  # 日后考虑将httpparty用Net/http代替
  response = HTTParty.post(url, 
          body: params,
          #奇怪，为什么这里用的是header的复数？
          headers: {'apiKey' => auth[:token], 'accessToken' => auth[:accesstoken]  }
        )
  response.parsed_response
end

def process( response, key, debug = false, &func )
  return response if debug

end