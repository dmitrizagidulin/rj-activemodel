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
require 'active_support/json'
require 'active_support/core_ext/object/to_json'
require "virtus"
require "virtus/attribute"

module RiakJson
  module ActiveDocument
    extend ActiveSupport::Concern
    
    included do
      include RiakJson::ActiveModel
      include Virtus.model  # Virtus is used to manage document attributes
      
      attr_accessor :key
      alias_method :id, :key  # document.id same as document.key, to maintain Rails idiom
    end
    
    # Needed by the RiakJson::Collection API
    # Invoked by the document's collection, when writing to RiakJson
    def to_json_document
      self.attributes.to_json
    end
    
    module ClassMethods
      # Converts from a RiakJson::Document instance to an instance of ActiveDocument
      # @return [ActiveDocument, nil] ActiveDocument instance, or nil if the Document is nil
      def from_document(doc, persisted=false)
        return nil if doc.nil?
        active_doc_instance = self.instantiate(doc.body)
        active_doc_instance.key = doc.key
        if persisted
          active_doc_instance.persist!  # Mark as persisted / not new
        end
        active_doc_instance
      end

      # Returns an ActiveDocument instance, given a JSON string
      # The JSON string is typically obtained from a RiakJson collection query
      # @return [ActiveDocument, nil] ActiveDocument instance, or nil if the JSON string is nil/empty
      def from_json(json_obj, key=nil)
        return nil if json_obj.nil? or json_obj.empty?
        attributes_hash = JSON.parse(json_obj)
        return nil if attributes_hash.empty?
        instance = self.instantiate(attributes_hash)
        if key.nil?
          # Load key from the JSON object
          key = attributes_hash['_id']
        end
        instance.key = key
        instance
      end
      
      # Returns an ActiveDocument instance, given a Hash of attributes
      def instantiate(attributes)
        self.new attributes
      end
    end
  end
end