module Integrations::Shopify::Products
  class PublishTranslation
    include Interactor

    delegate :user, :params, :original_content, :fail!, to: :context

    def call
      locale = params[:locale] || 'en'
      translations = []
      translations << {
        key: "title",
        value: params[:title],
        locale: locale,
        translatableContentDigest: Digest::SHA256.hexdigest(original_content[:title])
      } if params[:title].present? && original_content[:title].present?

      translations << {
        key: "body_html",
        value: params[:body_html],
        locale: locale,
        translatableContentDigest: Digest::SHA256.hexdigest(original_content[:description_html])
      } if params[:body_html].present? && original_content[:description_html].present?

      translations << {
        key: "handle",
        value: params[:handle],
        locale: locale,
        translatableContentDigest: Digest::SHA256.hexdigest(original_content[:handle])
      } if params[:handle].present? && original_content[:handle].present?

      translations << {
        key: "meta_title",
        value: params.dig(:seo, :title),
        locale: locale,
        translatableContentDigest: Digest::SHA256.hexdigest(original_content.dig(:seo, :title))
      } if params.dig(:seo, :title).present? && original_content.dig(:seo, :title).present?

      translations << {
        key: "meta_description",
        value: params.dig(:seo, :description),
        locale: locale,
        translatableContentDigest: Digest::SHA256.hexdigest(original_content.dig(:seo, :description))
      } if params.dig(:seo, :description).present? && original_content.dig(:seo, :description).present?

      mutation = <<~MUTATION
        mutation {
          translationsRegister(
            resourceId: "#{params[:id]}",
            translations: [
              #{translations.map { |t| %(
                {
                  key: "#{t[:key]}",
                  value: "#{t[:value]}",
                  locale: "#{t[:locale]}",
                  translatableContentDigest: "#{t[:translatableContentDigest]}"
                }
              )}.join(',')}
            ]
          ) {
            userErrors {
              field
              message
            }
          }
        }
      MUTATION

      integration = user.integrations.find(params[:shopify_id])
      fail!(errors: "No Shopify store connected!") unless integration

      session = ShopifyAPI::Auth::Session.new(
        shop: integration.domain,
        access_token: integration.token,
      )
      ShopifyAPI::Context.activate_session(session)

      client = ShopifyAPI::Clients::Graphql::Admin.new(session: session)
      response = client.query(query: mutation)
      result = response.body["data"]["translationsRegister"]

      if result["userErrors"].any?
        fail!(errors: result["userErrors"])
      end
    rescue => e
      context.fail!(message: "Error publishing translation: #{e.message}")      
    end
  end
end