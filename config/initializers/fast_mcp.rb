# frozen_string_literal: true

# FastMcp - Model Context Protocol for Rails with StreamableHTTP (2025-06-18)
# This initializer sets up the MCP middleware using StreamableHttpTransport

require 'fast_mcp'

# Create MCP server
mcp_server = FastMcp::Server.new(
  name: Rails.application.class.module_parent_name.underscore.dasherize,
  version: '1.0.0'
)

# Register tools and resources after Rails initialization
Rails.application.config.after_initialize do
  # Discover and register all tools and resources
  tools = ApplicationTool.descendants
  resources = ApplicationResource.descendants

  mcp_server.register_tools(*tools) if tools.any?
  mcp_server.register_resources(*resources) if resources.any?

  Rails.logger.info "[MCP] Registered #{tools.count} tools and #{resources.count} resources"
end

# Wrap Rails app with StreamableHttpTransport
# The transport handles /mcp requests, passes others to Rails
Rails.application.config.middleware.insert(
  0,
  FastMcp::Transports::StreamableHttpTransport,
  mcp_server,
  logger: Logger.new($stdout, level: Logger::INFO),
  path: '/mcp',
  # ↓ Allow every Origin header ↓
  allowed_origins: [/.*/],
  # ↓ Allow every remote IP ↓
  allowed_ips: [/.*/],
  localhost_only: false
)