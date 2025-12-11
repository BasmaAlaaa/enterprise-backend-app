module Interactor::Transactionable
  extend ActiveSupport::Concern

  included do
    def call
      ActiveRecord::Base.transaction do
        super
      end
    end
  end
end
