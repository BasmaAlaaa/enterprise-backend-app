module SearchConsole
  class Index
    include Interactor

    delegate :integration, :fail!, to: :context

    def call
      service = Integrations::Google::GoogleAuthHandler.new(integration)
      response = service.list_sites
      if response.respond_to?(:error)
        fail!(error: response[:error], status: response[:status])
      else
        context.sites = response
      end
    end
  end
end
