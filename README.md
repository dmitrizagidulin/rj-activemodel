# RiakJson::ActiveModel

ActiveModel integration for [Riak Json](https://github.com/basho-labs/riak_json)

## Requirements
 - Ruby 1.9+
 - Riak build with [Riak Json](https://github.com/basho-labs/riak_json) and Solr/Yokozuna enabled 
   (see [Setup](https://github.com/basho-labs/riak_json#setup) section for instructions)
 - [riak_json](https://github.com/basho-labs/riak_json_ruby_client) Ruby Client gem installed locally
 
## Installation
Build the ```riak_json``` gem for local installation:
```bash
git clone git@github.com:basho/riak_json_ruby_client.git
cd riak_json_ruby_client
bundle install
rake build
# => riak_json 0.0.2 built to pkg/riak_json-0.0.2.gem
```
Download and install ```riak_json-active_model``` and dev dependencies:
```bash
git clone https://github.com/dmitrizagidulin/rj-activemodel.git
cd rj-activemodel
gem install ../riak_json_ruby_client/pkg/riak_json-0.0.2.gem
bundle install
```
## Usage
RiakJson::ActiveModel extends the Riak Json Ruby Client to provide a familiar Rails style API, 
to help developers use JSON documents in their models and controllers.

The project provides an ActiveDocument mixin, with the following features:
 - Partially implements the Rails ActiveModel API.
   (Specifically, passes the [ActiveModel Lint Test suite](http://api.rubyonrails.org/classes/ActiveModel/Lint/Tests.html))
 - Uses [Virtus](https://github.com/solnic/virtus) for document attributes, defaults and coercions
 - Provides a simple persistence layer with ```save()```, ```find()```, ```update()``` and ```destroy()``` methods.
 - Provides validations for attributes
 
### Using RiakJson in a Rails-like model
To use RiakJson in your model code, add ```riak_json-active_model``` to your Gemfile,
and ```include``` RiakJson::ActiveDocument in your model class.
```ruby
# models/user.rb
class User
  include RiakJson::ActiveDocument
  
  attribute :username, String
  attribute :email, String
  attribute :country, String, default: 'USA'
  
  validates_presence_of :username
end
```
You can now create user documents, save them, and validate.
```ruby
# Try saving an invalid document
new_user = User.new
new_user.valid?  # => false
puts user.errors.messages  # => {:username=>["can't be blank"]}
new_user.save  # => false (does not actually save, since document not valid)
new_user.save!  # => raises RiakJson::InvalidDocument exception

# Now make it valid
new_user.username = 'HieronymusBosch'
new_user.valid?  # => true
new_user.save  # => saves and loads the generated key into document
new_user.key  # => 'EmuVX4kFHxxvlUVJj5TmPGgGPjP'
```
To load a document by key, use ```find()```:
```ruby
user = User.find('EmuVX4kFHxxvlUVJj5TmPGgGPjP')
```
When used as a rails model, the usual ```link_to```/route-based helpers work:
```erb
# In a user view file
<%= link_to @user.username, @user %> # => <a href="/users/EmuVX4kFHxxvlUVJj5TmPGgGPjP">HieronymusBosch</a>
<%= link_to 'Edit', edit_user_path(@user) %>  # => <a href="/users/EmuVX4kFHxxvlUVJj5TmPGgGPjP/edit">Edit</a>
# In a controller
redirect_to users_url
```
Querying:
```ruby
User.where({ country: 'USA' }.to_json)   # => array of US user instances
```
## Unit Testing
To run both unit and integration tests:
```
bundle exec rake test
```
Note: By default, integration tests assume that Riak is listening on ```127.0.0.1:8098```
(the result of ```make rel```).

To specify alternate host and port, use the ```RIAK_HOST``` and ```RIAK_PORT``` env variables:
```
RIAK_HOST=127.0.0.1 RIAK_PORT=10018 bundle exec rake test
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
