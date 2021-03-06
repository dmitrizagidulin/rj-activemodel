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

require 'test_helper'
require 'active_model/lint'

# Runs the ActiveModel::Lint test suite, to make sure a model fits the ActiveModel API
# See http://yehudakatz.com/2010/01/10/activemodel-make-any-ruby-object-feel-like-activerecord/
class ActiveModelLintTest < MiniTest::Unit::TestCase
  include ActiveModel::Lint::Tests
  
  def setup
    # Sample RiakJson::ActiveModel instance. See test/examples/models/user.rb
    @model = User.new
  end
end