

module OpenAi::BatchArticles::BlogPosts
  class GenerateContentPrompts <  OpenAi::Batch::GeneratePrompts
    include Interactor

    delegate :params, :fail!, to: :context

    private
    def prompt_content(attribute)
      " #{set_internal_link_prompt}
      From this submitted topic [#{attribute[:topic]}] and title #{attribute[:title]}, write the article with consistent headings, subheadings and paragraphs using [#{params[:tone]}] tone of voice and follow this detailed instructions:
      DO NOT include the title in the article.
      Make sure that the first line is the reading time estimate at the beginning.
      Add bulleted outlines at the beginning.
      Add high search volume topic tags.
      Focus on readability.
      Organize by topic clusters.
      #{creativity_level_prompt}.
      #{include_keywords_prompt}
      #{avoid_keywords_prompt}
      Make sure to stay consistent and cover the topic completely.
      #{internal_link_prompt}
      #{extra_links_prompt}
      #{additional_instructions_prompt}
      End with a short and comprehensive conclusion and credible references.
      Make the article around 5000 character.
      Use #{params[:language]} Language.
      #{article_type_prompt}.
      Please generate content in well-formed HTML suitable for rich text editors. The content should directly use HTML tags like <p>, <a href="">, etc., without any markdown or code block formatting.
      "
    end

    def internal_link_prompt
      return "" unless params[:internal_links].present?

      "Include these links in InternalLinkInput in the article."
    end

    def set_internal_link_prompt
      return "" unless params[:internal_links].present?

      "InternalLinkInput = [{title: Placeholder for the url, url: the given url}] = #{params[:internal_links]}"
    end

    def include_keywords_prompt
      return unless params[:include_keywords].present?

      "Use Keywords: #{params[:include_keywords]}"
    end

    def avoid_keywords_prompt
      return unless params[:avoid_keywords].present?

      "Avoid Keywords: #{params[:avoid_keywords]}"
    end

    def additional_instructions_prompt
      return "" unless params[:user_prompt]

      "Additional Instructions : #{params[:user_prompt]}"
    end

    def article_type_prompt
      return "" unless params[:article_type].present?

      "Follow this article type = #{params[:article_type]}"
    end

    def creativity_level_prompt
      return "" unless params[:creativity_level].present?

      "Set #{params[:creativity_level]} creativity level."
    end

    def extra_links_prompt
      return "" unless params[:extra_links].present?

      "Include #{params[:extra_links]} as extra links with included topic related statistics and quotes."
    end

    def field
      "article_content"
    end

    def custom_id(attribute)
      "content-#{attribute[:title]}"
    end

    def generation_used
      3
    end
  end
end