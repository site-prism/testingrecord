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
      def create_accessible_collection!
        ivar_name = "@#{name}s"
        instance_variable_set(ivar_name, [])
        define_singleton_method(:"#{name}s") { instance_variable_get(ivar_name) }
      end

      # Set the type of model, this should be one of `:singular` or `:plural`
      #
      # @return [Symbol]
      def type(type)
        @type = type
      end

      private

      def name
        to_s.snake_case
      end
    end
  end
end
