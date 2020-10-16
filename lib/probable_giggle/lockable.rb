require 'probable_giggle/lock'

module ProbableGiggle
  module Lockable
    DEFAULT_COMMENT = ''.freeze

    def with_lock(name, comment: DEFAULT_COMMENT, timeout: Lock::DEFAULT_TIMEOUT)
      lock = Lock.new(name: name, comment: comment)
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
      raise AlreadyLockedError, "Could not obtain lock on [#{lock.name}]"
    end
  end
end
