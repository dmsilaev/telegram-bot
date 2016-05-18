require 'telegram/bot/config_methods'

module Telegram
  extend Bot::ConfigMethods

  module Bot
    class Error < StandardError; end
    class NotFound < Error; end

    # Error class for events when chat is not available anymore for bot.
    # While Telegram has same error codes for different messages and there is no
    # official docs for this error codes it uses `description` to
    # check response.
    class StaleChat < Error
      DESCRIPTIONS = [
        'bot was kicked',
        "can't write to",
        'group chat is deactivated',
      ].freeze

      class << self
        def match_response?(response)
          description = response['description'].to_s
          DESCRIPTIONS.any? { |x| description[x] }
        end
      end
    end

    autoload :Botan,              'telegram/bot/botan'
    autoload :Client,             'telegram/bot/client'
    autoload :ClientStub,         'telegram/bot/client_stub'
    autoload :DebugClient,        'telegram/bot/debug_client'
    autoload :Initializers,       'telegram/bot/initializers'
    autoload :Middleware,         'telegram/bot/middleware'
    autoload :UpdatesController,  'telegram/bot/updates_controller'
    autoload :UpdatesPoller,      'telegram/bot/updates_poller'
  end
end

require 'telegram/bot/railtie' if defined?(Rails)
