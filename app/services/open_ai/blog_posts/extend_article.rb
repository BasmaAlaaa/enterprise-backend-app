module OpenAi::BlogPosts
  class ExtendArticle < OpenAi::GenerateStream
    include Interactor
    GENERATION_USED = 2

    private

    def prompt
      # params = {
      #   content: "<h2>Introduction to Men's Fashion Trends 2023</h2><p>As the new year unfolds, men's fashion takes a bold step forward, integrating classic elements with modern twists. The <a href=\"https://rubixteststore.myshopify.com/blogs/new-blog/top-mens-fashion-trends-2023-style-essentials-9\" rel=\"noopener noreferrer\" target=\"_blank\">Top Men's Fashion Trends 2023 - Style Essentials</a> article offers a comprehensive guide to staying ahead in the fashion game.</p><h2>The Role of Men's Responsibilities in Fashion Choices</h2><p>Today's man juggles various roles - from being a supportive partner to a nurturing father. These roles significantly influence their wardrobe, as men seek out versatile pieces that offer both style and practicality.</p>"
      # }

      "Here is the current section of my article:

      #{params[:content]}

      I would like to extend this section further. Please continue the article in the same style,
      Please continue the content in well-formed HTML suitable for rich text editors. The content should directly use HTML tags like <p>, <h1>, <a href="">, etc., without any markdown or code block formatting., aiming for approximately 250-350 words.
      "
    end
    
    def json_key
      'content'
    end

    def stream_channel
       "open_ai_stream_article_extend_content_#{integration.id}"
    end

    def field
      "article_content"
    end

  end
end