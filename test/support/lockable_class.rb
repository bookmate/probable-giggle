class LockableClass
  include ProbableGiggle::Lockable

  LOCK_NAME = 'lock'.freeze

  def call
    with_lock(LOCK_NAME) {}
  end
end
