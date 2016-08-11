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
        Logger.new(STDOUT).tap { |l| l.level = Logger::DEBUG }
      end
    end

    extend Storage
  end
end
