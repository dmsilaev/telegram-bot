module Telegram
  module Bot
    class Botan
      TRACK_URI = 'https://api.botan.io/track'.freeze

      autoload :ControllerHelpers, 'telegram/bot/botan/controller_helpers'
      class Error < Bot::Error; end

      extend Initializers
      prepend Async
      include DebugClient

      class << self
        def by_id(id)
          Telegram.botans[id]
        end
      end

      attr_reader :client, :token

      def initialize(token = nil, **options)
        @client = HTTPClient.new
        @token = token || options[:token]
      end

      def track(event, uid, payload = {})
        http_request(:post, TRACK_URI, {name: event, uid: uid}, payload.to_json)
      end

      def request(method, uri, query = {}, body = nil)
        res = http_request(method, uri, query.merge(token: token), body)
        status = res.status
        return JSON.parse(res.body) if 300 > status
        result = JSON.parse(res.body) rescue nil # rubocop:disable RescueModifier
        err_msg = "#{res.reason}: #{result && result['info'] || '-'}"
        raise Error, err_msg
      end

      def http_request(method, uri, query, body)
        client.request(method, uri, query, body)
      end
    end
  end
end
