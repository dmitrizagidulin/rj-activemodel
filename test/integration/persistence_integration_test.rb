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

TEST_USERNAME = 'earl'
TEST_USERNAME_2 = 'count'

def test_user(test_key='earl-123')
  user = User.new username: TEST_USERNAME, email: 'earl@desandwich.com'
  user.key = test_key
  user
end

describe "a RiakJson::ActiveDocument's Persistence Layer" do  
  it "can save a document" do
    test_key = 'earl-123'
    user = test_user(test_key)
    generated_key = user.save
    generated_key.wont_be_nil "Key not generated from document.save"
    generated_key.wont_be_empty "Key not generated from document.save"
    user.key.must_equal generated_key
    
    refute user.new_record?, "Document should not be marked as new after saving"
    assert user.persisted?, "Document should be marked as persisted after saving"
  end
  
  it "can read, update and delete a document" do
    test_key = 'earl-123'
    found_user = User.find(test_key)
    found_user.must_be_kind_of User
    found_user.key.must_equal test_key
    
    new_attributes = {username: 'earl_de', email: 'earl_de@gmail.com' }
    found_user.update(new_attributes)  # Also saves
    
    updated_user = User.find(test_key)
    updated_user.username.must_equal 'earl_de'
    
    new_user = User.new username: 'george', email: 'george@washington.com'
    new_user.key = 'george'
    new_user.save
    new_user.destroy!
  end
  
  it "can simulate all() via all_for_field()" do
    docs = User.all_for_field(:username)
    docs.wont_be_empty
    docs.first.must_be_kind_of User
  end
  
  it "returns an empty array for queries that return no results" do
    query = { username: 'nonexistent' }.to_json
    result = User.where(query)
    result.must_be_empty
  end
  
  it "implements a find_one() method to pass through queries to the collection" do
    query = { username: TEST_USERNAME_2 }.to_json
    user = User.find_one(query)
    user.wont_be_nil "User.find_one should return a valid result."
    user.must_be_kind_of User
    user.username.must_equal TEST_USERNAME_2
  end
end