module GoogleAds
  class UpdateGeneration
    include Interactor

    delegate :generation_id, :keyword_ideas, :fail!, to: :context
    
    def call
      return if generation.blank?

      generation.content = keyword_ideas

      fail!(generation.errors) unless generation.done!
    end

    private

    def generation
      @generation ||= Generation.find_by(id: generation_id)
    end
  end
end