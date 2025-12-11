class BatchGroup < ActiveRecord::Base
  belongs_to :integration
  has_many :generations, dependent: :destroy

  enum status: {
    processing: 0,
    failed: 1,
    done: 2,
    hidden: 3,
    streaming: 4,
    cancelled: 5
  }

  enum generation_type: {
    batch_article_content: 0,
    batch_article_seo: 1,
    batch_article_excerpt: 2
  }
end