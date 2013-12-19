# RiakJson::ActiveModel

ActiveModel integration for [Riak Json](https://github.com/basho-labs/riak_json)

## Requirements
 - Ruby 1.9+
 - Riak build with [Riak Json](https://github.com/basho-labs/riak_json) and Solr/Yokozuna enabled 
   (see [Setup](https://github.com/basho-labs/riak_json#setup) section for instructions)
 - [riak_json](https://github.com/basho-labs/riak_json_ruby_client) Ruby Client gem installed locally

## Installation

Build the ```riak_json``` gem for local installation:
```
git clone git@github.com:basho/riak_json_ruby_client.git
cd riak_json_ruby_client
bundle install
rake build  # => riak_json 0.0.2 built to pkg/riak_json-0.0.2.gem
```
Download and install ```riak_json-active_model``` and dev dependencies:
```
git clone https://github.com/dmitrizagidulin/rj-activemodel.git
cd rj-activemodel
gem install ../riak_json_ruby_client/pkg/riak_json-0.0.2.gem
bundle install
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
