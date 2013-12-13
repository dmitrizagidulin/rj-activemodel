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

require "active_model"
require "active_model/naming"
require "active_support/concern"
require "riak_json/active_model/active_document"
require "riak_json/active_model/conversion"
require "riak_json/active_model/persistence"
require "riak_json/active_model/version"

module RiakJson::ActiveModel
  extend ActiveSupport::Concern

  included do
    extend ActiveModel::Naming
    include RiakJson::ActiveModel::Conversion
    include RiakJson::ActiveModel::Persistence
  end
  
  def destroyed?
    false
  end
  
  def errors
    obj = Object.new
    def obj.[](key) [] end
    def obj.full_messages()  [] end
    obj
  end
  
  def new_record?
    true
  end
  
  def persisted?
    !self.new_record?
  end
  
  def valid?
    true
  end
  
  module ClassMethods
    # @return [RiakJson::Client] The client for the current thread.
    def client
      Thread.current[:riak_json_client] ||= RiakJson::Client.new
    end
  
    # Sets the client for the current thread.
    # @param [RiakJson::Client] value the client
    def client=(value)
      Thread.current[:riak_json_client] = value
    end
    
    def collection
      @@collection ||= self.client.collection(self.collection_name)
    end
    
    def collection=(collection_obj)
      @@collection = collection_obj
    end
    
    def collection_name
      self.model_name.plural
    end
  end
  
  class SampleModel < RiakJson::Document
    include RiakJson::ActiveModel
  end
end

