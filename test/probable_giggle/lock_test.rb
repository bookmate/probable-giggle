require 'test_helper'
require 'probable_giggle/lock'
require 'support/fake_mysql_connection'

class ProbableGiggle::LockTest < Minitest::Test
  attr_reader :lock, :logger, :connection

  def setup
    @connection = FakeMysqlConnection.new
    @logger = ->(message) { }
    @lock = ProbableGiggle::Lock.new(name: 'lock1', comment: 'comment1', connection: connection, logger: logger)
  end

  def test_lock
    assert_equal(lock, lock.lock, 'Lock#lock grabs the lock and returns himself')
  end

  def test_comment
    assert_equal(
      lock.comment,
      'comment1',
      'Lock#comment incapsulates an SQL comment'
    )
  end

  def test_locked_when_locked
    connection = FakeMysqlConnection.new(return_value: 68)
    lock = ProbableGiggle::Lock.new(name: 'already_locked', comment: 'comment1', connection: connection, logger: logger)
    assert lock.locked?
  end

  def test_locked_when_unlocked
    connection = FakeMysqlConnection.new(return_value: nil)
    lock = ProbableGiggle::Lock.new(name: 'already_locked', comment: 'comment1', connection: connection, logger: logger)
    refute lock.locked?
  end

  def test_owned
    assert lock.owned?
  end

  def test_obtain
    assert lock.obtain
  end

  def test_release
    assert lock.release
  end
end
