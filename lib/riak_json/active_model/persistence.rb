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
      self.class.collection.insert(self)
    end
    
    module ClassMethods
      def find(key)
        json_obj = self.collection.get_raw_json(key)
        unless json_obj.nil?
          instance = self.from_json(json_obj)
          instance.key = key
          instance
        end
      end
    end
  end
end