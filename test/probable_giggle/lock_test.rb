require 'test_helper'
require 'probable_giggle/lock'
require 'support/fake_mysql_connection'

class ProbableGiggle::LockTest < Minitest::Test
  def setup
    connection = FakeMysqlConnection.new
    logger = Logger.new('/dev/null')
    @lock = ProbableGiggle::Lock.new(name: 'lock1', connection: connection, logger: logger)
  end

  def test_obtain
    assert @lock.obtain
  end

  def test_release
    assert @lock.release
  end
end
