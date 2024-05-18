require 'logger'

module ProbableGiggle
  class Configuration
    module Storage
      attr_writer :logger
      attr_accessor :connection

      def logger
        @logger ||= default_logger
      end

      private

      def default_logger
        ->(message) { puts(message) }
      end
    end

    extend Storage
  end
end
