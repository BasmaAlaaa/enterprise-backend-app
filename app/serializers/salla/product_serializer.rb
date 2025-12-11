class Salla::ProductSerializer < ActiveModel::Serializer
  attributes :title, :id, :description, :seo, :image, :status, :images

  def title
    object['name']
  end

  def id
    object.id
  end

  def description
    object.description
  end

  def images
    object.images
  end

  def seo
    {
      title: object.metadata.title, 
      description: object.metadata.description,
      url: object.metadata.url
    }
  end

  def image
    object.images.first || {}
  end

  def status
    case object.status
    when 'hidden', 'deleted'
      'draft'
    when 'sale', 'out'
      'active'
    else
      'unknown' 
    end
  end

end