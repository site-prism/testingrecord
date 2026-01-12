# frozen_string_literal: true

require_relative '../validation'

module TestingRecord
  module DSL
    module Builder
      # [TestingRecord::DSL::Builder::Settings]
      # Ways in which we can configure our individual models
      module Settings
        include DSL::Validation::Input

        attr_reader :__primary_key

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

        # Create a cache of the entities, named according to the classname
        #
        # @return [Symbol]
        def caching(option)
          raise Error, 'Invalid caching option, must be :enabled or :disabled' unless caching_valid?(option)
          return unless option == :enabled

          instance_variable_set(:@all, [])
          define_singleton_method(:all) { instance_variable_get(:@all) }
        end

        # Sets the primary key value of all entities - used for deduplication
        # TODO: Use this for deduplication proper
        #
        # @return [Symbol]
        def primary_key(option)
          instance_variable_set(:@__primary_key, option.to_sym)
        end

        private

        def add_to_cache(entity)
          self.current = entity
          all << entity
          TestingRecord.logger.debug("Entity: #{entity} added to cache")
        end

        def update_cache(entity)
          # TODO: This needs implementing properly
        end
      end
    end
  end
end
