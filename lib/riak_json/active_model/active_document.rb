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
require "virtus"

module RiakJson
  module ActiveDocument
    extend ActiveSupport::Concern
    
    included do
      include RiakJson::ActiveModel
      include Virtus.model
      
      attr_accessor :key
    end
    
    def to_json_document
      self.attributes.to_json
    end
    
    module ClassMethods
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
      
      def instantiate(attributes)
        self.new attributes
      end
    end
  end
end