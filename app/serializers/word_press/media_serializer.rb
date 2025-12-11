class WordPress::MediaSerializer < ActiveModel::Serializer
  attributes :id, :image

  def id
    object.id
  end

  def image
    {
      id: object.id,
      url: object&.url,
      alt: object&.alt
    }

  end
end