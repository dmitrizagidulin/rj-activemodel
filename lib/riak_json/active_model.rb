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
require "riak_json/active_model/version"

module RiakJson::ActiveModel
  extend ActiveSupport::Concern

  included do
    extend ActiveModel::Naming
    include RiakJson::ActiveModel::Conversion
  end

  def collection_name
    self.class.model_name.plural
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
  
  class SampleModel < RiakJson::Document
    include RiakJson::ActiveModel
  end
end

