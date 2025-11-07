# frozen_string_literal: true

require 'automation_helpers/extensions/string'
require_relative 'dsl'

module TestingRecord
  # The top level Model. Most of the behaviours specified here are fairly rudimentary ones that will then
  # include other behaviour(s), from the included modules
  class Model
    extend DSL::Builder::Helpers
    extend DSL::Builder::Settings

    attr_reader :attributes

    # Creates an instance of the model
    #   -> Adding it to the cache if caching is enabled
    #   -> Creating iVar values for each property that was set
    #     -> For now these will be set to `''` or `[]`
    #
    # @return [TestingRecord::Model]
    def self.create(attributes = {})
      new(attributes).tap do |entity|
        add_to_cache(entity) if respond_to?(cache_name)
        properties.each do |property|
          if property[:type] == :singular
            entity.instance_variable_set("@#{property[:name]}", nil)
          else
            entity.instance_variable_set("@#{property[:name]}s", [])
          end
        end
      end
    end

    def initialize(attributes = {})
      @attributes = attributes
    end
  end
end
