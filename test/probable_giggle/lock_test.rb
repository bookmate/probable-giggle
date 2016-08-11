require 'test_helper'
require 'probable_giggle/lock'
require 'support/fake_mysql_connection'

class ProbableGiggle::LockTest < Minitest::Test
  def setup
    ProbableGiggle::Configuration.connection = FakeMysqlConnection.new
    ProbableGiggle::Configuration.logger = Logger.new('/dev/null')
  end

  def teardown
    ProbableGiggle::Configuration.logger = nil
    ProbableGiggle::Configuration.connection = nil
  end

  def test_obtain
    lock = ProbableGiggle::Lock.new(name: 'lock1')
    assert lock.obtain
  end

  def test_release
    lock = ProbableGiggle::Lock.new(name: 'lock1')
    assert lock.release
  end
end
