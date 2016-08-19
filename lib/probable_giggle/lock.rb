require 'probable_giggle/configuration'

module ProbableGiggle
  class Lock

    MAX_NAME_LENGTH = 64
    MAX_NAME_LENGTH_ERROR_MSG = "Lock name length must be less than " \
      "#{MAX_NAME_LENGTH} characters".freeze
    DEFAULT_TIMEOUT = 0

    attr_reader :name, :timeout
    attr_reader :logger, :connection

    def initialize(name:, timeout: DEFAULT_TIMEOUT, logger: Configuration.logger, connection: Configuration.connection)
      fail ArgumentError.new(MAX_NAME_LENGTH_ERROR_MSG) if name.length >= MAX_NAME_LENGTH
      @name = name
      @timeout = timeout
      @logger = logger
      @connection = connection
    end

    def obtain
      logger.debug("Obtain lock for resource [#{name}]")
      exec("GET_LOCK(#{quoted_name}, #{timeout})")
    end

    def release
      logger.debug("Obtain lock for resource [#{name}]")
      exec("RELEASE_LOCK(#{quoted_name})")
    end

    private

    def exec(fun)
      query = "SELECT #{fun} AS result"
      result = connection.select_value(query)
      logger.debug("Query: [#{query}]; Result: [#{result}]")
      1 == result
    end

    def quoted_name
      @quoted_name ||= connection.quote(name)
    end
  end
end
