# frozen_string_literal: true

require 'automation_helpers/extensions/string'

module TestingRecord
  # The top level Model. Most of the behaviours specified here are fairly rudimentary ones that will then
  # include other behaviour(s), from the included modules
  class Model
    class << self
      # Create a cache of the entities, named according to the classname
      #
      # @return [Symbol]
      def caching(option)
        return unless option == :enabled

        instance_variable_set(ivar_name, [])
        define_singleton_method(cache_name) { instance_variable_get(ivar_name) }
      end

      def create(attributes)
        new(attributes).tap do |entity|
          add_to_cache(entity) if respond_to?(cache_name)
        end
      end

      # Set the type of model, this should be one of `:singular` or `:plural`
      #
      # @return [Symbol]
      def type(type)
        @type = type
      end

      private

      def add_to_cache(entity)
        # TODO: Cache entity as the current entity for model class
        send(cache_name) << entity
        # TODO: Add log message (Requires adding logger)
      end

      def cache_name
        :"#{to_s.snake_case}s"
      end

      def ivar_name
        "@#{to_s.snake_case}s"
      end
    end

    def initialize(attributes)
      @attributes = attributes
    end
  end
end
