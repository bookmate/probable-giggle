module ProbableGiggle
  autoload :Lockable, 'probable_giggle/lockable'

  ProbableGiggleError = Class.new(StandardError)
  AlreadyLockedError = Class.new(ProbableGiggleError)
end

require 'probable_giggle/configuration'
