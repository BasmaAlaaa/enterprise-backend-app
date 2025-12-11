class Integrations::Shopify::BulkUpdate::PrepareLocaleInput
  include Interactor

  delegate :params, :edges, :fail!, to: :context

  def call
    prepared_data = []
    edges_hash = edges.each_with_object({}) do |edge, hash|
      product_id = edge["node"]["id"].split('/').last
      hash[product_id] = {title: edge["node"]["title"],description_html: edge["node"]["descriptionHtml"],handle: edge["node"]["handle"],seo: {title: edge["node"]["seo"]["title"],description: edge["node"]["seo"]["description"]}}
    end

    params[:batch].each do |item|
      product_id = item[:input][:id]
      original_content = edges_hash[product_id]
      translations = []
      translations << {
        key: "title",
        value: item[:input][:title],
        locale: item[:input][:locale],
        translatableContentDigest: Digest::SHA256.hexdigest(original_content[:title])
      } if item[:input][:title].present? && original_content[:title].present?

      translations << {
        key: "body_html",
        value: item[:input][:descriptionHtml],
        locale: item[:input][:locale],
        translatableContentDigest: Digest::SHA256.hexdigest(original_content[:description_html])
      } if item[:input][:descriptionHtml].present? && original_content[:description_html].present?

      translations << {
        key: "handle",
        value: item[:input][:handle],
        locale: item[:input][:locale],
        translatableContentDigest: Digest::SHA256.hexdigest(original_content[:handle])
      } if item[:input][:handle].present? && original_content[:handle].present?

      if item[:input][:seo].present?
      translations << {
        key: "meta_title",
        value: item[:input][:seo][:title],
        locale: item[:input][:locale],
        translatableContentDigest: Digest::SHA256.hexdigest(original_content[:seo][:title])
      } if item[:input][:seo][:title].present? && original_content[:seo][:title].present?

      translations << {
        key: "meta_description",
        value: item[:input][:seo][:description],
        locale: item[:input][:locale],
        translatableContentDigest: Digest::SHA256.hexdigest(original_content[:seo][:description])
      } if item[:input][:seo][:description].present? && original_content[:seo][:description].present?
      end

      mutation_input = {
        resourceId: "gid://shopify/Product/#{product_id}",
        translations: translations
      }
      prepared_data << mutation_input
    end
    context.prepared_data = prepared_data
  end
end
