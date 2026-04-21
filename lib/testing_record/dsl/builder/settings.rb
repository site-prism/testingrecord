# frozen_string_literal: true

require_relative '../validation'

module TestingRecord
  module DSL
    module Builder
      # [TestingRecord::DSL::Builder::Settings]
      # Ways in which we can configure our individual models
      module Settings
        include DSL::Validation::Input

        def __primary_key
          @__primary_key ||=
            if superclass.respond_to?(:__primary_key)
              superclass.__primary_key
            else
              TestingRecord.default_primary_key
            end
        end

        # Create a cache of the entities, named according to the classname
        #
        # @return [Symbol]
        def caching(option)
          raise Error::InvalidConfigurationError, 'Invalid caching option, must be :enabled or :disabled' unless caching_valid?(option)
          return unless option == :enabled

          instance_variable_set(:@all, [])
          define_singleton_method(:all) { instance_variable_get(:@all) }
        end

        # Sets the primary key value of all entities - used for deduplication
        # TODO: Use this for deduplication proper
        #
        # @return [Symbol]
        def primary_key(option)
          raise InvalidConfigurationError, 'Invalid primary key value, must be a Symbol' unless option.is_a?(Symbol)

          instance_variable_set(:@__primary_key, option)
        end
      end
    end
  end
end
