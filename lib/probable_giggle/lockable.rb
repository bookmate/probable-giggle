require 'probable_giggle/lock'

module ProbableGiggle
  module Lockable
    AlreadyLocked = Class.new(StandardError)

    def with_lock(name, timeout: Lock::DEFAULT_TIMEOUT)
      lock = Lock.new(name: name)
      if lock.obtain(timeout)
        yield
      else
        on_already_locked(lock)
      end
    ensure
      lock.release
    end

    private

    def on_already_locked(lock)
      fail AlreadyLocked, "Could not obtain lock on [#{lock.name}]"
    end
  end
end
