module ProbableGiggle
  autoload :Lockable, 'probable_giggle/lockable'
  Error = Class.new(StandardError)
  AlreadyLockedError = Class.new(Error)
end

require 'probable_giggle/configuration'
