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
    it "should have a nil key when first initialized" do
      @user_document.key.must_be_nil
    end
    
    it "should respond to to_json_document()" do
      assert @user_document.respond_to?(:to_json_document)
    end
  end
  
  context "when new/instantiated" do
    it "should know its collection name" do
      # a document's collection name is used in ActiveModel::Conversion compatibility
      @user_document.collection_name.must_equal 'users'
    end
  end
end