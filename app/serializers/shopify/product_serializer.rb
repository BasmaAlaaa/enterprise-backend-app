class Shopify::ProductSerializer < ActiveModel::Serializer
  attributes :title, :id, :description, :seo, :status, :images, :image, :updated_at, :has_alt_text

  def title
    object.title
  end

  def id
    object.id
  end

  def description
    object.description
  end

  def images
    object['images']['edges'].map do |edge|
      image= edge['node']
      {
        id: image['id'],
        url: image['src'],
        altText: image['altText']
      }
    end
  end

  def seo
    {
      title: object.seo&.title, 
      description: object.seo&.description,
      url: object&.handle
    }
  end

  def image
    image = images.first
    return {} unless image
    {
      id: image[:id],
      url: image[:url],
      altText: image[:altText]
    }
  end

  def status
   object.status
  end

  def updated_at
    object.updatedAt
  end

  def has_alt_text
    has_atleast_one_alt = false
    has_atleast_one_missing_alt = false

    images.each do |image|
      alt_text = image['altText'] 
      has_atleast_one_alt = true if alt_text.present?
      has_atleast_one_missing_alt = true if alt_text.blank?
    end

    return "No" unless has_atleast_one_alt
    return "Yes" unless has_atleast_one_missing_alt
    "Some"
  end

end