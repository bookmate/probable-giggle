require 'probable_giggle/configuration'
require 'securerandom'

module ProbableGiggle
  class Lock
    MAX_NAME_LENGTH = 64
    MAX_NAME_LENGTH_ERROR_MSG = "Lock name length must be less than " \
      "#{MAX_NAME_LENGTH} characters".freeze
    DEFAULT_TIMEOUT = 5 # seconds

    attr_reader :name
    attr_reader :logger
    attr_reader :connection
    attr_reader :comment

    def initialize(name:, comment:, logger: Configuration.logger, connection: Configuration.connection)
      raise ArgumentError.new(MAX_NAME_LENGTH_ERROR_MSG) if name.length >= MAX_NAME_LENGTH

      @name = name
      @logger = logger
      @comment = comment
      @connection = connection.respond_to?(:call) ? connection.call : connection
    end

    def lock
      # MariaDB doesn't support timeout: -1 which means wait infinite
      # so emulate this behaviour
      until obtain(10)
        # try again
      end
      self
    end

    def locked?
      !is_used_lock.nil?
    end

    def owned?
      obtained_connection == self_connection
    end

    def sleep(timeout)
      unlock
      sleep timeout
      try_lock
    end

    def synchronize
      lock
      yield
    ensure
      release
    end

    def try_lock
      obtain(0)
    end

    def unlock
      raise "Resource [#{name}] wasn't locked by the current connection" unless release
    end

    def get_lock(timeout = DEFAULT_TIMEOUT)
      logger.debug("Obtain lock for resource [#{name}]")
      exec("GET_LOCK(#{quoted_name}, #{timeout})")
    end
    alias_method :obtain, :get_lock

    def release_lock
      logger.debug("Obtain lock for resource [#{name}]")
      exec("RELEASE_LOCK(#{quoted_name})")
    end
    alias_method :release, :release_lock

    def is_used_lock
      select("IS_USED_LOCK(#{quoted_name})")
    end
    alias_method :obtained_connection, :is_used_lock

    private

    def self_connection
      select('CONNECTION_ID()'.freeze)
    end

    def select(fun)
      query = "SELECT #{fun} AS #{unique_column_name} -- #{comment}"
      connection.select_value(query).tap do |result|
        logger.debug("Query: [#{query}]; Result: [#{result}]")
      end
    end

    def exec(fun)
      result = select(fun)
      result == 1
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
