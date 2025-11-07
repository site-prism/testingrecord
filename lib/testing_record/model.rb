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

    class << self
      attr_accessor :current

      # Creates an instance of the model
      #   -> Adding it to the cache if caching is enabled
      #   -> Creating iVar values for each property that was set
      #     -> For now these will be set to `''` or `[]`
      #
      # @return [TestingRecord::Model]
      def create(attributes = {})
        new(attributes).tap do |entity|
          add_to_cache(entity) if respond_to?(cache_name)
          properties.each do |property|
            default_value = property[:type] == :singular ? '' : []
            entity.instance_variable_set("@#{property[:name]}", default_value)
          end
          Model.current = entity
        end
      end
    end

    def initialize(attributes = {})
      @attributes = attributes
    end
  end
end
