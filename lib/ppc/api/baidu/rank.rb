module PPC
  module API
    class Baidu
      class Rank< Baidu
        Service = 'Rank'

        def self.get_rank(auth, keyword, device)
          body = {:keyWords => [keyword], :device => 0, :region => 1000, :page => 0, :display => 0}
          response = request(auth, Service, 'getPreview', body)
          result = process(response, 'previewInfos' ){|x| x }
          p result
          data = result[:result][0]["data"]
          plain = Base64.decode64(data)
          gz = Zlib::GzipReader.new(StringIO.new(plain))
          html_result = gz.read
          gz.close
          puts html_result
        end

      end # keyword
    end # Baidu
  end # API
end # PPC