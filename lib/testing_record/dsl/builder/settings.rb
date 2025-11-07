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
              if property[:type] == :singular
                instance_variable_set("@#{property[:name]}", nil)
              else
                instance_variable_set("@#{property[:name]}s", [])
              end
            end
          end
        end

        # Sets a property on the model, this should have a name and an optional type (Defaults to `:singular`)
        #
        # @return [Array<Hash>]
        def property(name, type: :singular)
          raise Error, 'Invalid type option, must be :singular or :plural' unless type_valid?(type)

          if type == :singular
            attr_reader name
          else
            attr_reader :"#{name}s"
          end

          properties << { name:, type: }
        end

        def properties
          @properties ||= []
        end

        # Set the type of model, this should be one of `:singular` or `:plural`
        #
        # @return [Symbol]
        def type(option)
          raise Error, 'Invalid type option, must be :singular or :plural' unless type_valid?(option)

          @type = option
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
    end
  end
end
