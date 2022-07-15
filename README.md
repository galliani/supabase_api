# Supabase Api Ruby Client [![Gem](https://img.shields.io/gem/v/supabase_api?color=blue&label=version)](https://rubygems.org/gems/supabase_api) ![Build Status](https://github.com/galliani/supabase_api/workflows/spec/badge.svg)  [![Coverage](https://github.com/galliani/supabase_api/blob/main/badge.svg)](https://github.com/galliani/supabase_api) ![Commit](https://img.shields.io/github/last-commit/galliani/supabase_api)


Hi, this is a Ruby wrapper to access your Supabase tables via REST API in a manner similar to ActiveRecord model.

DISCLAIMER: This is not an official Ruby SDK.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
$ bundle add supabase_api
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
$ gem install supabase_api
```

## Usage


### Setup
Run these commands on the config or initializer file.

```ruby
# setups
require 'supabase_api' # if not using Rails
SupabaseApi::Config.base_url = 'https://yourrandomapisubdomain.supabase.co'
SupabaseApi::Config.api_key = 'veryrandomlongstring'
```

For production usage, of course it is recommended to use ENV variables manager like Figaro or Dotenv, which then will make your setup like this:
```ruby
# setups
require 'supabase_api' # if not using Rails
SupabaseApi::Config.base_url = ENV['SUPABASE_API_BASE_URL']
SupabaseApi::Config.api_key = ENV['SUPABASE_API_KEY']
```

This setup should be called as early as need be. If using rails, you can put it under `config/initializers` directory inside a file named `supabase_api.rb` as per the usual convention.


### With Rails
Create a ruby PORO class for your Supabase tables and inherit from the `SupabaseApi::Record` class.

```ruby
class Book < SupabaseApi::Record
  def self.table_name
    # put the name of the table you want to connect with from Supabase
    'books' # or 'Books', whatever you fancy
  end
end
```

Then after that you can access your Supabase table just like a `ActiveRecord`-backed models.

### Querying Data
```ruby
book_id_in_supabase = 100
Book.find(book_id_in_supabase)

# The line below will yield the same like above but will not raise any exception
book = Book.find_by_id(book_id_in_supabase)

# or you could call .where
Book.where(id: 100) # would yield the same result as above, also not raising exception

# .where works like you expect, passing another key-value pair as arguments
Book.where(name: 'some name of the book')

```

### Mutating Data

```ruby
book = Book.find(book_id_in_supabase)

# Assuming the books table has 'status' string column
book.status = 'archived'
book.save

# If you want to create a new book record
new_book = Book.new(
  name: 'New Book',
  status: 'pending'
)
new_book.save

# or
book = Book.create(
  name: 'New Book',
  status: 'pending'
)
book.id # => 100

# In case you regret creating it, you can delete the record
book.destroy
Book.find(100) # will raise an exception SupabaseApi::RecordNotFound
```

## TODO List
- add pagination.
- adapt command `#create` and `#update`  for the Record class to have multiple inserts and upserts respectively.
- add more graceful and robust error handler.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/galliani/supabase_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/galliani/supabase_api/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SupabaseApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/galliani/supabase_api/blob/master/CODE_OF_CONDUCT.md).
