## ------------------------------------------------------------------- 
## 
## Copyright (c) "2013" Basho Technologies, Inc.
##
## This file is provided to you under the Apache License,
## Version 2.0 (the "License"); you may not use this file
## except in compliance with the License.  You may obtain
## a copy of the License at
##
##   http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing,
## software distributed under the License is distributed on an
## "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
## KIND, either express or implied.  See the License for the
## specific language governing permissions and limitations
## under the License.
##
## -------------------------------------------------------------------

require 'minitest/autorun'
require 'minitest-spec-context'
require 'riak_json'
require 'riak_json/active_model'
require 'examples/models/user'
require 'examples/models/address_book'


# Set this to silence "[deprecated] I18n.enforce_available_locales will default to true in the future." warnings
I18n.config.enforce_available_locales = true

# :before_suite

# Ensure that the db is populated by users
user = User.new username: 'earl', email: 'earl@desandwich.com'
user.key = 'earl-123'
user.save

user = User.new username: 'count', email: 'count@demontecristo.com'
user.key = 'count-123'
user.save