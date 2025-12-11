module OpenAi::BlogPosts
  class GenerateExcerpt < OpenAi::Generate
    include Interactor
    GENERATION_USED = 3

    private

    def prompt
      # params = {
      #   language: "Arabic",
      #   content: "The world of fitness and health constantly buzzes with new trends, findings, and magic potions said to contribute to peak performance and well-being. Among these, the widespread acclaim and sustained popularity of creatine supplements merit particular attention.

      #   Why Creatine?
      #   Commonly associated with bodybuilders and athletes, creatine is a molecule naturally produced by your body to fuel muscles during high-intensity exercise. While creatine can also be sourced from various foods, its concentrated format in supplements is favored for more robust results. Here are the top 10 reasons why you should consider incorporating creatine supplements into your routines:

      #   1. Enhance Strength and Power
      #   Creatine increases the body's ability to produce energy quickly. With more energy, you can train harder and more often, leading to faster gains in strength and power.

      #   2. Accelerate Muscle Growth
      #   Creatine is the world's most effective supplement for adding muscle mass. It can optimize cell signaling responsible for repairing and new muscle growth.

      #   3. Faster Recovery
      #   The benefits of creatine extend beyond the workout itself. Its capacity to replenish energy stores translates into reduced muscle damage and faster recovery times.

      #   4. Boosts Performance During High-Intensity Workouts
      #   As creatine fuels your muscles, it gives you the ability to push harder during high-intensity workouts, leading to improved overall performance.

      #   5. Improve Brain Health
      #   Creatine helps maintain optimal brain health and function, particularly in aging individuals. By supporting energy supply to the brain, it can boost cognitive functions and decrease the risk of neurological diseases.

      #   6. May Lower Blood Sugar Levels
      #   Research suggests that creatine may help lower blood sugar levels, potentially reducing the risk of type 2 diabetes.

      #   7. Helps Improve Endurance Capacity
      #   Creatine supplementation can increase phosphocreatine stores in muscles, helping to prolong the duration of high-intensity exercise.

      #   8. Supports Bone Health
      #   Creatine promotes bone regeneration and bone cell growth, vital as one ages and bone health starts to deteriorate.

      #   9. Beneficial for Vegetarians and Vegans
      #   For those who don't consume meat, becoming deficient in creatine is a risk. A creatine supplement can fill this dietary void and ensure optimal levels for overall physiological functioning.

      #   10. Safe and Affordable
      #   Creatine is known for its long-term safety and availability at a reasonable price. It's a worthy addition to your daily regimen.
      #   7. Helps Improve Endurance Capacity
      #   Creatine supplementation can increase phosphocreatine stores in muscles, helping to prolong the duration of high-intensity exercise.

      #   3. Supports Bone Health
      #   Creatine promotes bone regeneration and bone cell growth, vital as one ages and bone health starts to deteriorate.

      #   4. Beneficial for Vegetarians and Vegans
      #   For those who don't consume meat, becoming deficient in creatine is a risk. A creatine supplement can fill this dietary void and ensure optimal levels for overall physiological functioning.

      #   15. Safe and Affordable
      #   Creatine is known for its long-term safety and availability at a reasonable price. It's a worthy addition to your daily regimen.

      #   Conclusion
      #   The value of creatine supplements extends far beyond the weights room. It has widespread impacts ranging from supporting brain health to enhancing muscle power. For those serious about their fitness goals or simply looking to optimize their overall well-being, creatine supplementation could be an excellent choice. Always remember to consult with a healthcare professional before starting any new supplementation regimen.

      #   Experience the numerous benefits that creatine supplementation has to offer by adding it to your fitness journey today!

      #   References
      #   This article does not replace professional medical advice. Always consult your physician before starting a new supplement routine.",
      # }
      "Generate a concise, engaging excerpt from a blog post about **#{params[:content]}**.
      length range 100-300 characters
      The excerpt should highlight the main theme,
      include a compelling question or statement to intrigue the reader,
      and end with a call-to-action encouraging further reading.
      Use #{params[:language]} Language


      return the output as json schema  of products
      follow this schema
      {
        'excerpt': GENERATED_EXCERPT        
      }
      "
    end

    def field
      "article_excerpt"
    end

  end
end