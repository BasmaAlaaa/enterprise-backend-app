class Salla::CollectionSerializer < ActiveModel::Serializer
  attributes :title, :id , :seo, :image

  def title
    object['name']
  end

  def id
    object.id
  end

  def image
    object.image
  end

  def seo
    {
      title: object.metadata.title, 
      description: object.metadata.description,
      url: object.metadata.url
    }
  end

end