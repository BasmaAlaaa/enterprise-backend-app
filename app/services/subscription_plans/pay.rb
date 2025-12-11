module SubscriptionPlans
  class Pay
    include Interactor

    delegate :subscription_plan, :code, :user, :fail!, to: :context

    def call
      handle_discount_code if code.present?
      fail!(errors: "Please cancel your subscription first.") if user.subscription
      if subscription_plan.name == "Free"
        result = SubscriptionPlans::AssignFreePlan.call(user: user)
        context.url = result.url if result.success?
      else
        session = create_payment_intent
        context.res = session
        context.session_url = session.url
      end
    end

    private

    def handle_discount_code
      is_valid_code = SubscriptionDiscounts::Validate.call(code: code)
      context.discount = is_valid_code.discount
      fail!(errors: is_valid_code.errors) unless is_valid_code.success?
      context.coupon_id = create_stripe_coupon
    end

    def create_payment_intent
      customer = find_or_create_stripe_customer
      subscription = create_subscription
      line_items = [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: subscription_plan.name
          },
          unit_amount: (subscription_plan.amount * 100).to_i, 
          recurring: {
            interval: subscription_plan.yearly? ? "year" : "month"
          }
        },
        quantity: 1,
      }]
      discounts = context.coupon_id.present? ? [{coupon: context.coupon_id}] : []
      session_params = {
        customer: customer.id,
        payment_method_types: ['card'],
        line_items: line_items,
        mode: 'subscription',
        success_url: 'https://context.success_url',
        cancel_url: "https://context.cancel_url",
        metadata: {local_subscription_id: subscription.id} ,
        discounts: discounts
      }
      Stripe::Checkout::Session.create(session_params)
    end

    def find_or_create_stripe_customer
      
        if user.stripe_customer_id.blank?
          customer = Stripe::Customer.create(email: user.email)
          user.update(stripe_customer_id: customer.id)
        else
          customer = Stripe::Customer.retrieve(user.stripe_customer_id)
        end
      rescue Stripe::StripeError => e
        Rails.logger.error "Stripe error: #{e.message}"
        return nil
      rescue => e
        Rails.logger.error "General error: #{e.message}"
        return nil
      
    
      customer
    end


    def create_stripe_coupon
      return nil unless context.discount.present?
      coupon_id = context.discount.code 
      begin
        existing_coupon = Stripe::Coupon.retrieve(coupon_id)
        return existing_coupon.id 
      rescue Stripe::InvalidRequestError => e
        Rails.logger.info "Coupon #{coupon_id} not found. Attempting to create a new one."
      end
      begin
        new_coupon = Stripe::Coupon.create(
          id: coupon_id,
          percent_off: context.discount.percentage,
          duration: 'once'
        )
        return new_coupon.id 
      rescue Stripe::StripeError => e
        Rails.logger.error "Stripe coupon creation failed: #{e.message}"
        nil
      rescue => e
        Rails.logger.error "Unexpected error during Stripe coupon creation: #{e.message}"
        nil
      end
    end
    
    
    def create_subscription
      subscription = Subscription.new(
        user_id: user.id,
        subscription_plan: subscription_plan,
        status: :pending,
        subscription_discount: context.discount,
        remaining_generations: subscription_plan.benefits["generations_per_month"],
        remaining_images: subscription_plan.benefits["images_per_month"],

      )
      context.subscription = subscription
      fail!(errors: subscription.errors) unless subscription.save
      subscription
    end

  end
end
