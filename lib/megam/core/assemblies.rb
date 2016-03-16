# Copyright:: Copyright (c) 2013-2016 Megam Systems
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
  class Assemblies < Megam::ServerAPI
    def initialize(o)
      @id = nil
      @accounts_id = nil
      @org_id = nil
      @name = nil
      @password = nil
      @assemblies = []
      @inputs = []
      @created_at = nil
      super(o)
    end

    def assemblies
      self
    end

    def id(arg=nil)
      if arg != nil
        @id = arg
      else
      @id
      end
    end

    def accounts_id(arg=nil)
      if arg != nil
        @accounts_id = arg
      else
      @accounts_id
      end
    end
    
    def org_id(arg=nil)
      if arg != nil
        @org_id = arg
      else
      @org_id
      end
    end

    def password(arg=nil)
      if arg != nil
        @password = arg
      else
      @password
      end
    end

    def name(arg=nil)
      if arg != nil
        @name = arg
      else
      @name
      end
    end

    def assemblies(arg=[])
      if arg != []
        @assemblies = arg
      else
      @assemblies
      end
    end

    def inputs(arg=[])
      if arg != []
        @inputs = arg
      else
      @inputs
      end
    end

    def created_at(arg=nil)
      if arg != nil
        @created_at = arg
      else
      @created_at
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
      index_hash["org_id"] = org_id
      index_hash["name"] = name
      index_hash["accounts_id"] = accounts_id
      index_hash["inputs"] = inputs
      index_hash["assemblies"] = assemblies
      index_hash["created_at"] = created_at
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
        "accounts_id" => accounts_id,
        "org_id" => org_id,
        "assemblies" => assemblies,
        "inputs" => inputs,
        "created_at" => created_at
      }
      result
    end

    def self.json_create(o)
      asm = new({})
      asm.id(o["id"]) if o.has_key?("id")
      asm.name(o["name"]) if o.has_key?("name")
      asm.accounts_id(o["accounts_id"]) if o.has_key?("accounts_id")
      asm.org_id(o["org_id"]) if o.has_key?("org_id")
      asm.assemblies(o["assemblies"]) if o.has_key?("assemblies") #this will be an array? can hash store array?
      asm.inputs(o["inputs"]) if o.has_key?("inputs")
      asm.created_at(o["created_at"]) if o.has_key?("created_at")
      asm
    end

    def self.from_hash(o)
      asm = self.new(o)
      asm.from_hash(o)
      asm
    end

    def from_hash(o)
      @id                = o["id"] if o.has_key?("id")
      @name              = o["name"] if o.has_key?("name")
      @accounts_id       = o["accounts_id"] if o.has_key?("accounts_id")
      @org_id            = o["org_id"] if o.has_key?("org_id")
      @assemblies        = o["assemblies"] if o.has_key?("assemblies")
      @inputs            = o["inputs"] if o.has_key?("inputs")
      @created_at        = o["created_at"] if o.has_key?("created_at")
      self
    end

    def self.create(params)
      asm = from_hash(params)
      asm.create
    end

    # Create the node via the REST API
    def create
      megam_rest.post_assemblies(to_hash)
    end

    # Load a account by email_p
    def self.show(o)
      asm = self.new(o)
      asm.megam_rest.get_one_assemblies(o[:assemblies_id])
    end

    def self.list(params)
      asm = self.new(params)
      asm.megam_rest.get_assemblies
    end

    def to_s
      Megam::Stuff.styled_hash(to_hash)
    end

  end
end
