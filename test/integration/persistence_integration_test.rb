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

describe "a RiakJson::ActiveDocument's Persistence Layer" do
  it "can read, save and delete a document" do
    user = User.new username: 'earl', email: 'earl@desandwich.com'
    test_key = 'earl-123'
    user.key = test_key
    generated_key = user.save
    generated_key.wont_be_nil "Key not generated from document.save"
    generated_key.wont_be_empty "Key not generated from document.save"
    user.key.must_equal generated_key
    
    found_user = User.find(test_key)
    found_user.must_be_kind_of User
    found_user.key.must_equal test_key
  end
end