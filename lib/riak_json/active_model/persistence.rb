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

require "active_support/concern"

module RiakJson::ActiveModel
  module Persistence
    extend ActiveSupport::Concern
    
    # Delete the document from its collection
    def destroy
      self.class.collection.remove(self)
      @destroyed = true
    end
    
    # Performs validations and saves the document
    # The validation process can be skipped by passing <tt>validate: false</tt>.
    # @return [String] Returns the key for the inserted document
    def save(options={:validate => true})
      return false if options[:validate] && !valid?
      result = self.class.collection.insert(self)
      self.persist!
      result
    end

    # Attempts to validate and save the document just like +save+ but will raise a +DocumentInvalid+
    # exception instead of returning +false+ if the doc is not valid.
    def save!(options={:validate => true})
      unless save
        raise RiakJson::DocumentInvalid.new(self)
      end
      true
    end
    
    # Update an object's attributes and save it
    def update(attrs)
      self.attributes = attrs
      self.save
    end
    
    # Update attributes (alias for update() for Rails versions < 4)
    def update_attributes(attrs)
      self.update(attrs)
    end
    
    module ClassMethods
      # Returns all documents (within results/pagination limit) 
      #  from a collection.
      # Implemented instead of all() to get around current RiakJson API limitations
      # @return [Array] of ActiveDocument instances
      def all_for_field(field_name)
        results_limit = 1000  # TODO: Fix hardcoded limit
        query = {
            field_name => {'$regex' => "/.*/"},
            '$per_page'=>results_limit
        }.to_json
        result = self.collection.find(query)
        result.documents.map {|doc| self.from_document(doc, persisted=true) }
      end
      
      # Load a document by key.
      # Not to be confused with collection.find() which is a 'find all' query
      def find(key)
        return nil if key.nil? or key.empty?
        doc = self.collection.find_by_key(key)
        self.from_document(doc, persisted=true)
      end
      
      # Return all documents that match the query
      def where(query)
        result = self.collection.find(query)
        result.documents.map do |doc| 
          self.from_document(doc, persisted=true)
        end
      end
      
      # Return the first document that matches the query
      def find_one(query)
        doc = self.collection.find_one(query)
        self.from_document(doc, persisted=true) 
      end
    end
  end
end