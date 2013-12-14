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
    
    def save
      result = self.class.collection.insert(self)
      self.persist
      result
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
        result.documents.map {|doc| self.from_json(doc.to_json) }
      end
      
      def find(key)
        json_obj = self.collection.get_raw_json(key)
        unless json_obj.nil?
          self.from_json(json_obj, key)
        end
      end
    end
  end
end