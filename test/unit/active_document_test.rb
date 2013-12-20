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

describe 'a RiakJson::ActiveDocument' do
  before do
    # See test/examples/models/user.rb
    # User class includes the RiakJson::ActiveDocument mixin
    @user_document = User.new
  end
  
  context "should implement the RiakJson Collection API" do
    it "has a key" do
      @user_document.key.must_be_nil # first initialized
      test_key = 'george'
      @user_document.key = test_key
      @user_document.key.must_equal test_key
      @user_document.to_partial_path.must_equal 'users/george'
      # Test for the .id alias
      @user_document.id.must_equal test_key
    end
    
    it "should respond to to_json_document()" do
      assert @user_document.respond_to?(:to_json_document)
    end
  end
  
  context "when new/instantiated" do
    it "should be marked as new" do
      @new_doc = User.new
      assert @new_doc.new_record?
      refute @new_doc.persisted?
      refute @new_doc.destroyed?
    end
    
    it "should know its collection name" do
      # a document's collection name is used in ActiveModel::Conversion compatibility
      User.collection_name.must_equal 'users'
    end
    
    it "should have access to a Client instance" do
      User.client.must_be_kind_of RiakJson::Client
    end
    
    it "should have access to a Collection instance" do
      User.collection.must_be_kind_of RiakJson::Collection
    end
  end
  
  context "provides Persistence capability" do
    it "can be converted to JSON and back" do
      user = User.new username: 'earl', email: 'earl@desandwich.com'
      json_obj = user.to_json_document
      json_obj.must_be_kind_of String
      
      new_user = User.from_json(json_obj)
      new_user.must_be_kind_of User
      new_user.username.must_equal 'earl'
    end
    
    it "from_json() returns nil if passed in an empty result string" do
      User.from_json(nil).must_be_nil
      User.from_json('').must_be_nil
      User.from_json([].to_json).must_be_nil
    end
    
    it "can be converted from a RiakJson::Document instance" do
      # Conversion from a nil document also results in nil
      User.from_document(nil).must_be_nil
      
      doc_key = '1234'
      doc_body = { username: 'earl', email: 'earl@desandwich.com', :language=>"en" }
      doc = RiakJson::Document.new(doc_key, doc_body)
      
      user = User.from_document(doc)
      user.must_be_kind_of User
      user.key.must_equal doc_key
      user.attributes.must_equal doc_body
    end
    
    it "implements a find (by key) method, via its collection" do
      user_key = 'abe'
      User.collection = MiniTest::Mock.new
      User.collection.expect :find_by_key, nil, [user_key]
      User.find(user_key)
      User.collection.verify
      
      # Replace User collection object so other tests aren't affected
      User.collection = User.client.collection(User.collection_name)
    end
    
    it "returns nil when doing a find() for nil or empty key" do
      User.find(nil).must_be_nil
      User.find('').must_be_nil
    end
  end
end