# Legitable

Tables are easier to read.  Legitable makes it easy to display plain text output in tabular form.

Given a normal series of hash objects as rows _(where "normal" means that all hashes have the same
keys)_, the first row's keys will be taken as the table's column headers; deviations in subsequent
hashes will be ignored.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'legitable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install legitable

## Usage

First, create a table object:

```ruby
table = Legitable::Table.new
```

Then add some rows:

```ruby
table << { name: 'Joss Whedon', phone: '444-555-1212' }
table << { name: 'JJ Abrams', phone: '333-555-1212' }
```

And then you can display it:
```ruby
puts table.to_s
```

    NAME        | PHONE       
    --------------------------
    Joss Whedon | 444-555-1212
    JJ Abrams   | 333-555-1212

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelhelbling/legitable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
