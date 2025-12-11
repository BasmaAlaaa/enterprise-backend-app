class WordPress::CollectionSerializer < ActiveModel::Serializer
  attributes :title, :id , :description, :image, :seo, :updated_at, :has_alt_text

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
    return {} if object.image.blank?
    {
      id: object.image[:id],
      url: object.image[:url] ,
      altText: object.image[:alt]
    }
  end

  def seo 
   object.seo || {}
  end

  def updated_at
    object&.updated_at
  end

  def has_alt_text
    return "No" if image.blank?
    alt_text = image['altText']
    has_alt = alt_text.present?
    has_alt ? "Yes" : "No"
  end
end