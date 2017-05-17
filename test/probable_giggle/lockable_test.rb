require 'test_helper'
require 'probable_giggle/lockable'
require 'support/fake_mysql_connection'
require 'support/lockable_class'

class ProbableGiggle::LockableTest < Minitest::Test
  attr_reader :lock, :logger, :connection, :lock_name

  def setup
    @connection = FakeMysqlConnection.new(return_value: 0)
    @lock_name = 'lock'
  end

  def test_with_lock_when_locked
    ProbableGiggle::Configuration.stub :connection, connection do
      assert_raises ProbableGiggle::AlreadyLockedError do
        LockableClass.new.call
      end
    end
  end
end
