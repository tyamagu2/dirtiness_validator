# DirtinessValidator [![Build Status](https://travis-ci.org/tyamagu2/dirtiness_validator.svg?branch=master)](https://travis-ci.org/tyamagu2/dirtiness_validator)

Dirtiness Validator validates the value of the specified attribute against its previous value.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dirtiness_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dirtiness_validator

## Usage

Pass dirtiness option to the validates method of your ActiveRecord model.

```
class Vote < ActiveRecord::Base
  validates :count, dirtiness: { greater: true }
  validates :last_voted_at, dirtiness: { greater: true, message: 'is invalid.' }
end
```

Configuration options other than :message can be supplied with a symbol or a proc.

```
# This validates that last_voted_at.to_date is greater than last_voted_at_was.to_date.
validates :last_voted_at, dirtiness: { greater: :to_date }

# This does the same.
validates :last_voted_at, dirtiness: { greater: -> (value) { value.to_date } }
```

Note that Dirtiness Validator skips validation if the record is not persisted.

To use Dirtiness Validator with ActiveModel, you must include ActiveModell:Dirty and call its methods as instructed in your model.
Your model's #persisted? method should return true if the changes to the its attributes are ever applied;
otherwise Dirtiness Validator never invokes its validation.

```
class Vote
  include ActiveModel::Validations
  include ActiveModel::Dirty

  validates :count, dirtiness: { greater_or_equal: true }

  def count
    @count
  end

  def count=(val)
    return if @count == val
    count_will_change!
    @count = val
  end

  def save
    changes_applied
    @persisted = true
  end

  def persisted?
    !!@persisted
  end
end
```

## Configuration Options

- :message - A custom error message.

- :greater - Specifies the value must be greater than the previous value.

- :greater_or_equal - Specifies the value must be greater than or equal the previous value.

- :equal - Specifies the value must be equal to the previous value.

- :not_equal - Specifies the value must be other than the previous value.

- :less - Specifies the value must be less than the previous value.

- :less_or_equal - Specifies the value must be less than or equal the previous value.

There is also a list of default options for every validator:
_:if_, _:unless_, _:on_, _:allow_nil_, _:allow_blank_, and _:strict_.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tyamagu2/dirtiness_validator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
