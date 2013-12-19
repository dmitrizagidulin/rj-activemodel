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
require "riak_json/active_model/errors"
require "riak_json/active_model/persistence"
require "riak_json/active_model/version"

module RiakJson::ActiveModel
  extend ActiveSupport::Concern

  included do
    extend ActiveModel::Naming
    include ActiveModel::Validations
    include RiakJson::ActiveModel::Persistence
  end
  
  # Has this document been deleted from RiakJson?
  # Required by ActiveModel::Conversion API
  # @return [Boolean]
  def destroyed?
    @destroyed ||= false
  end
  
  # Is this a new, unsaved document?
  # Required by ActiveModel::Conversion API
  # @return [Boolean]
  def new_record?
    !persisted?
  end
  
  # Mark the document as saved/persisted
  # Called by +save+, and when instantiating query results (see ::Persistence)
  def persist!
    @persisted = true
  end
  
  # Has this document been saved to RiakJson?
  # Required by ActiveModel::Conversion API
  # @return [Boolean]
  def persisted?
    @persisted ||= false
  end
  
  # Returns an Enumerable of all key attributes if any is set, or +nil+ if
  # the document is not persisted
  # Required by ActiveModel::Conversion API
  def to_key
    self.new_record? ? nil : [self.key]
  end
  
  # Returns an instance of an ActiveModel object (ie, itself)
  # Required by ActiveModel::Conversion API
  def to_model
    self
  end
  
  # Returns a +string+ representing the object's key suitable for use in URLs,
  # or +nil+ if <tt>persisted?</tt> is +false+.
  # Required by ActiveModel::Conversion API
  # @return [String, nil]
  def to_param
    self.key
  end
  
  # Returns a +string+ identifying the path associated with the object.
  # ActionPack uses this to find a suitable partial to represent the object.
  # Used in Rails helper methods such as +link_to+
  # Required by ActiveModel::Conversion API
  # @return [String]
  def to_partial_path
    "#{self.class.collection_name}/#{self.key}"
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
    
    # Returns a RiakJson::Collection instance for this document
    def collection
      @collection ||= self.client.collection(self.collection_name)
    end
    
    # Sets the RiakJson::Collection instance for this document
    def collection=(collection_obj)
      @collection = collection_obj
    end
    
    # Returns string representation for the collection name
    # Uses ActiveModel::Naming functionality to derive the name
    def collection_name
      self.model_name.plural
    end
  end
end

