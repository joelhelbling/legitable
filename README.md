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

First, require it:

```ruby
require 'legitable'
```

Then, create a table object:

```ruby
table = Legitable::Table.new
```

Now add some rows:

```ruby
table << { name: 'joss whedon', phone: '444-555-1212' }
table << { name: 'jj abrams', phone: '333-555-1212' }
```

And then you can display it:
```ruby
puts table.to_s
```

    NAME        | PHONE       
    --------------------------
    joss whedon | 444-555-1212
    jj abrams   | 333-555-1212

### Right-aligned columns

Some data, such as numbers, look better aligned to the right instead
of to the left:

```ruby
table = Legitable::Table.new(alignment: { bytes: :right })

table << { bytes: 12, file: 'foo.zip' }
table << { bytes: 1200, file: 'bar.zip' }
table << { bytes: 12000000, file: 'baz.zip' }
```

Which makes the numbers much easier to read:

       BYTES | FILE   
    ------------------
          12 | foo.zip
        1200 | bar.zip
    12000000 | baz.zip

### Changing up the look

Some aspects of the table are configurable, such as the column
delimiter (which defaults to `" | "`) and the character used as
a header row separator (which defaults to `"-"`).

```ruby
table = Legitable::Table.new(delimiter: '  ', separator: '=')
```

Which would give us this:


    NAME         PHONE       
    =========================
    joss whedon  444-555-1212
    jj abrams    333-555-1212

### Formatting columns

Sometimes the raw data as it comes in isn't exactly what you want
to display.  So you can define formatters:

```ruby
title = Legitable::Table.new do
  formatting :name do |value|
    "_#{value.titleize}_"
  end
end
```

Which, of course, improves the display of the names column:


    NAME          | PHONE       
    ----------------------------
    _Joss Whedon_ | 444-555-1212
    _JJ Abrams_   | 333-555-1212

And, of course, you can do something similar for the column headings:

```ruby
title = Legitable::Table.new do
  formatting_headers do |header|
    header.capitalize
  end
end
```

Which makes the headers a little nicer:

    Name        | Phone       
    --------------------------
    joss whedon | 444-555-1212
    jj abrams   | 333-555-1212


## Caveats

It should be obvious that this utility pulls in all rows, and then
displays them taking into account the widest values when determining
the appropriate column width.  Accordingly, all rows to be processed
will be in memory as long as the table object exists.  So this isn't
a good tool for formatting a terrabyte of tabular data.

The focus is on _display_ of data.  Think of a `Legitable::Table` as
a _page_ of data.  If you have multiple pages of data, you'd probably
want to repeat the headers anyway at some point, so it makes sense to
just create a new table after every *n* rows.

This puts me in mind of some ideas for the future:

- ability to "flush" all rows so that the table's formatting can be
  re-used and re-loaded.
- ability to fix the width of a column and to word wrap within that
  width in order to control the overall width of the table.
- ANSI color support

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelhelbling/legitable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
