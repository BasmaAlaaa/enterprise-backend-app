FactoryBot.define do
  factory :statistics do
    association :integration
     product_title { 0 }
     product_seo{ 0 }
     product_description{ 0 }
     collection_description{ 0 }
     collection_seo{ 0 }
     article_content{ 0 }
     article_excerpt{ 0 }
     article_seo{ 0 }
     images{ 0 }
     image_alt_text{ 0 }
     total_words{ 0 }
     article_title{ 0 }
  end
end
