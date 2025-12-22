# frozen_string_literal: true

require_relative '../validation'

module TestingRecord
  module DSL
    module Builder
      # [TestingRecord::DSL::Builder::Settings]
      # Ways in which we can configure our individual models
      module Settings
        include DSL::Validation::Input

        # Create a cache of the entities, named according to the classname
        #
        # @return [Symbol]
        def caching(option)
          raise Error, 'Invalid caching option, must be :enabled or :disabled' unless caching_valid?(option)
          return unless option == :enabled

          instance_variable_set(ivar_name, [])
          define_singleton_method(cache_name) { instance_variable_get(ivar_name) }
        end

        # Sets an attribute on the model
        #
        # @return [Array<Symbol>]
        def attribute(name)
          attr_reader name

          attributes << name
        end

        def attributes
          @attributes ||= []
        end

        private

        def add_to_cache(entity)
          self.current = entity
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
    end
  end
end
