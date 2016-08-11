require 'test_helper'
require 'probable_giggle/configuration'

class ProbableGiggle::ConfigurationTest < Minitest::Test
  def teardown
    ProbableGiggle::Configuration.logger = nil
    ProbableGiggle::Configuration.connection = nil
  end

  def test_logger
    assert_kind_of(Logger, ProbableGiggle::Configuration.logger, 'Default logger is a logger')
    ProbableGiggle::Configuration.logger = :custom_logger
    assert_equal(:custom_logger, ProbableGiggle::Configuration.logger, 'Logger can be set to any value')
  end

  def test_connection
    assert_nil(ProbableGiggle::Configuration.connection, 'Connection is nil by default')
    ProbableGiggle::Configuration.connection = :mysql_connection
    assert_equal(:mysql_connection, ProbableGiggle::Configuration.connection, 'Connection can be set to any value')
  end
end
