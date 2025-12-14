# frozen_string_literal: true

class ApplicationTool < ActionTool::Base
    include Rails.application.routes.url_helpers
    class ToolError < StandardError; end

    private

    # allows you to write `return error("some message")`
    def error(message)
        raise ToolError, message
    end

end
