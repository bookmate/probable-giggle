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

    def obtained?
      !is_used_lock.nil?
    end

    def is_used_lock
      select("IS_USED_LOCK(#{quoted_name})")
    end

    private

    def select(fun)
      query = "SELECT #{fun} AS #{unique_column_name}"
      result = connection.select_value(query)
      logger.debug("Query: [#{query}]; Result: [#{result}]")

      result
    end

    def exec(fun)
      1 == select(fun)
    end

    def quoted_name
      @quoted_name ||= connection.quote(name)
    end

    # Prevent SQL-caching by AR
    def unique_column_name
      "t#{SecureRandom.hex}"
    end
  end
end
