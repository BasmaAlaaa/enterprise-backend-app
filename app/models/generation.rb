class Generation < ApplicationRecord
  belongs_to :integration
  belongs_to :project , optional: true 
  belongs_to :batch_group, optional: true
  
  scope :alt_text, -> { where(generation_type: Generation.generation_types.slice(
    :alt_text_collection, :alt_text_media, :alt_text_article, :alt_text_product
  ).values) }

  scope :by_type, ->(generation_type) {
    where(generation_type: generation_type)
  }

  scope :by_project, ->(project_id) {
  where(project_id: project_id)
}
  
  enum status: {
    processing: 0,
    failed: 1,
    done: 2,
    hidden: 3,
    streaming: 4,
    canceled: 5
  }

  enum generation_type: {
    article: 0,
    products: 1,
    collections: 2,
    article_extend_content: 3,
    article_optimize_content: 4,
    alt_text_product: 5,
    alt_text_collection: 6,
    alt_text_media: 7,
    alt_text_article: 8,
    keyword_ideas: 9
  }
end
