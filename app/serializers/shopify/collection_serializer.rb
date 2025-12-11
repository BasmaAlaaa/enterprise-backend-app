class Shopify::CollectionSerializer < ActiveModel::Serializer
  attributes :title, :id , :description, :seo, :image, :updated_at, :has_alt_text

  def title
    object.title
  end

  def id
    object.id
  end

  def description
    object.description
  end

  def image
    object.image || {}
  end

  def seo
    {
      title: object.seo&.title, 
      description: object.seo&.description,
      url: object&.handle
    }
  end

  def updated_at
    object.updatedAt
  end

  def has_alt_text
    return "No" if image.blank?
    alt_text = image['altText']
    has_alt = alt_text.present?
    has_alt ? "Yes" : "No"
  end
end