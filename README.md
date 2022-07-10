# SupabaseApi

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
SupabaseApi::Sample.base_url = 'https://yourrandomapisubdomain.supabase.co'
SupabaseApi::Sample.api_key = 'veryrandomlongstring'
```

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

```ruby
book_id_in_supabase = 100
Book.find(book_id_in_supabase)

# The line below will yield the same like above but will not raise any exception
book = Book.find_by_id(book_id_in_supabase)

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
- add command `.where` for the Record class to be able to query the table.
- add command `.update` for the Record instance.
- add command `#update` for the Record class to have multiple upserts.
- add more graceful and robust error handler.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/supabase_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/supabase_api/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SupabaseApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/supabase_api/blob/master/CODE_OF_CONDUCT.md).
