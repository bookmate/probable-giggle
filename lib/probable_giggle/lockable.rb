require 'probable_giggle/lock'

module ProbableGiggle
  module Lockable
    def with_lock(name)
      lock = Lock.new(name: name)
      if lock.obtain
        yield
      else
        on_already_locked(lock)
      end
    ensure
      lock.release
    end

    private

    def on_already_locked(lock)
      lock.logger.debug("Resource [#{lock.name}] is already locked. Do nothing")
    end
  end
end
