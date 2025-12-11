class Integrations::Shopify::BulkUpdate::UploadFileToShopify
  include Interactor

  delegate :staged_target, :params, :items, :fail!, to: :context
  def call
    Tempfile.create(['jsonl_file', '.jsonl']) do |file|
      params[:batch]&.each do |item|
        file.puts(item.to_h.to_json)
      end
      file.flush
      form_data = []

      staged_target["parameters"].each do |param|
        form_data << [param["name"], param["value"]]
      end
      uri = URI.parse(staged_target["url"])
      request = Net::HTTP::Post.new(uri)

      form_data << ['file', File.open(file.path)]

      request.set_form form_data, 'multipart/form-data'

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end
      puts "Response: #{response.inspect}"
      fail!(errors: response.msg)  unless response.code.to_i == 201
    end
  end
end