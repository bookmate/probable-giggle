# ProbableGiggle

[![Build Status](https://travis-ci.org/bookmate/probable-giggle.svg?branch=master)](https://travis-ci.org/bookmate/probable-giggle)

Simple distributed locking using a shared database instance. Battle-tested in production with MySQL and MariaDB

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'probable-giggle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install probable-giggle

## Usage

Put it to `initializers/probable_giggle.rb`


```ruby
ProbableGiggle::Configuration.connection = -> { ActiveRecord::Base.connection }
ProbableGiggle::Configuration.logger = Rails.logger
```

Somewhere in your project


```ruby
class MultiServerTaskRunner
  include ProbableGiggle::Lockable

  def run_exclusively
    with_lock('lock1') { do_some_work }
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bookmate/probable-giggle.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

