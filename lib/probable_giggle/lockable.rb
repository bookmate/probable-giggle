require 'probable_giggle/lock'

module ProbableGiggle
  module Lockable
    def with_lock(name, timeout: Lock::DEFAULT_TIMEOUT)
      lock = Lock.new(name: name)
      obtained = false

      begin
        obtained = lock.obtain(timeout)
        return yield if obtained
      ensure
        lock.release if obtained
      end

      on_already_locked(lock)
    end

    private

    def on_already_locked(lock)
      fail AlreadyLockedError, "Could not obtain lock on [#{lock.name}]"
    end
  end
end
