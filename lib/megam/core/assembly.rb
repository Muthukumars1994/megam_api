# Copyright:: Copyright (c) 2012, 2014 Megam Systems
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Megam
  class Assembly < Megam::ServerAPI
    def initialize(email=nil, api_key=nil, host=nil)
      @id = nil
      @name = nil
      @tosca_type = nil
      @components = []
      @policies=[]
      @inputs = []
      @outputs = []
      @status = nil

      super(email, api_key, host)
    end

    def assembly
      self
    end

    def id(arg=nil)
      if arg != nil
        @id = arg
      else
      @id
      end
    end

    def name(arg=nil)
      if arg != nil
        @name = arg
      else
      @name
      end
    end

    def tosca_type(arg=nil)
      if arg != nil
        @tosca_type = arg
      else
      @tosca_type
      end
    end

    def components(arg=[])
      if arg != []
        @components = arg
      else
      @components
      end
    end

    def policies(arg=[])
      if arg != []
        @policies = arg
      else
      @policies
      end
    end

    def inputs(arg=[])
      if arg != []
        @inputs = arg
      else
      @inputs
      end
    end

    def outputs(arg=[])
      if arg != []
        @outputs = arg
      else
      @outputs
      end
    end

    def status(arg=nil)
      if arg != nil
        @status = arg
      else
      @status
      end
    end

    def error?
      crocked  = true if (some_msg.has_key?(:msg_type) && some_msg[:msg_type] == "error")
    end

    # Transform the ruby obj ->  to a Hash
    def to_hash
      index_hash = Hash.new
      index_hash["json_claz"] = self.class.name
      index_hash["id"] = id
      index_hash["name"] = name
      index_hash["tosca_type"] = tosca_type
      index_hash["components"] = components
      index_hash["policies"] = policies
      index_hash["inputs"] = inputs
      index_hash["outputs"] = outputs
      index_hash["status"] = status
      index_hash
    end

    # Serialize this object as a hash: called from JsonCompat.
    # Verify if this called from JsonCompat during testing.
    def to_json(*a)
      for_json.to_json(*a)
    end

    def for_json
      result = {
        "id" => id,
        "name" => name,
        "tosca_type" => tosca_type,
        "components" => components,
        "policies" => policies,
        "inputs" => inputs,
        "outputs" => outputs,
        "status" => status
      }

      result
    end

    def self.json_create(o)
      asm = new
      asm.id(o["id"]) if o.has_key?("id")
      asm.name(o["name"]) if o.has_key?("name")
      asm.tosca_type(o["tosca_type"]) if o.has_key?("tosca_type")
      asm.components(o["components"]) if o.has_key?("components")
      asm.policies(o["policies"]) if o.has_key?("policies") #this will be an array? can hash store array?
      asm.inputs(o["inputs"]) if o.has_key?("inputs")
      asm.outputs(o["outputs"]) if o.has_key?("outputs")
      asm.status(o["status"]) if o.has_key?("status")
      asm
    end

    def self.from_hash(o,tmp_email=nil, tmp_api_key=nil, tmp_host=nil)
      asm = self.new(tmp_email, tmp_api_key, tmp_host)
      asm.from_hash(o)
      asm
    end

    def from_hash(o)
      @id                = o["id"] if o.has_key?("id")
      @name              = o["name"] if o.has_key?("name")
      @tosca_type        = o["tosca_type"] if o.has_key?("tosca_type")
      @components        = o["components"] if o.has_key?("components")
      @policies          = o["policies"] if o.has_key?("policies")
      @inputs            = o["inputs"] if o.has_key?("inputs")
      @outputs           = o["outputs"] if o.has_key?("outputs")
      @status            = o["status"] if o.has_key?("status")
      self
    end


    def self.show(params)
      asm = self.new(params["email"], params["api_key"], params["host"])
      asm.megam_rest.get_one_assembly(params["id"])
    end

     def self.update(params)
      asm = from_hash(params, params["email"] || params[:email], params["api_key"] || params[:api_key], params["host"] || params[:host])
      asm.update
    end

    # Create the node via the REST API
    def update
      megam_rest.update_assembly(to_hash)
    end

    def to_s
      Megam::Stuff.styled_hash(to_hash)
    end

  end
end
