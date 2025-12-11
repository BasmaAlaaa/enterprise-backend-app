module OpenAi::BlogPosts
  class OptimizeArticle < OpenAi::GenerateStream
    include Interactor
    GENERATION_USED = 3

    private

    def prompt
      # params = {
      #   content: "Arabic",
      #   internal_links: [{title: "product", url: "product url page"}],
      #   include_keywords: "Summer,Hot",
      #   avoid_keywords: "Winter,Cold",
      #   title: "Retail Trends: Adapting to Changing Consumer Behavior",
      #   excerpt: "Discover the transformative power of creatine supplementation - from turbocharging muscle growth to fortifying brain health. Are you ready to unlock your peak performance? Dive into the world of creatine and elevate your fitness journey today!"
      # }
      "Optimize this article content for SEO #{params[:content]}, keep the same article context and write the article with consistent headings, subheadings and paragraphs using the same tone of voice and follow this detailed instructions:
      Add reading time estimate at the beginning (after h1).
      Add bulleted outlines at the beginning (after h1).
      Add high search volume topic tags.
      Focus on readability.
      Organize by topic clusters.
      #{include_keywords_prompt}
      #{avoid_keywords_prompt}
      Make sure to stay consistent and cover the topic completely.
      #{internal_link_prompt}.
      End with a short and comprehensive conclusion and credible references.
      

      Please generate content in well-formed HTML suitable for rich text editors. The content should directly use HTML tags like <p>, <h1>, <a href="">, etc., without any markdown or code block formatting.
      "
    end


    def internal_link_prompt
      return "" unless params[:internal_links].present?

      "Include  these links in InternalLinkInput in the article."
    end

    def include_keywords_prompt
      return unless params[:include_keywords].present?

      "Use Keywords: #{params[:include_keywords]}"
    end

    def avoid_keywords_prompt
      return unless params[:avoid_keywords].present?

      "Avoid Keywords: #{params[:avoid_keywords]}"
    end

    def json_key
      "article"
    end

    def stream_channel
      "open_ai_stream_article_optimize_content_#{integration.id}"
    end

    def field
      "article_content"
    end

  end
end