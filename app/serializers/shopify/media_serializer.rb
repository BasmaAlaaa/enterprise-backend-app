class Shopify::MediaSerializer < ActiveModel::Serializer
  attributes :id, :image

  def id
    object.id
  end

  def image
    {
      id: object.image&.id,
      url: object.image&.url,
      alt: object.image&.altText
    }

  end
end