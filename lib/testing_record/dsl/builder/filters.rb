# frozen_string_literal: true

module TestingRecord
  module DSL
    module Builder
      # [TestingRecord::DSL::Builder::Filters]
      # Ways in which we can filter our collection to find specific models
      module Filters
        # Checks to see whether an entity exists with the provided attributes
        #
        # @return [Boolean]
        def exists?(attributes)
          find_by(attributes).any?
        end

        # Finds an entity with the provided email address
        #   If one is found, set it as the current entity
        #
        # @return [TestingRecord::Model, nil]
        def with_email(email_address)
          find_by({ email_address: })&.first&.tap { |entity| entity.class.current = entity }
        end

        private

        # Finds all entities that match specified attribute values
        #
        # @return [Array<TestingRecord::Model>]
        def find_by(attributes)
          pool = all
          attributes.each do |key, value|
            TestingRecord.logger.debug("Current user pool size: #{pool.length}")
            TestingRecord.logger.debug("Filtering User list by #{key}: #{value}")
            pool = pool.select { |entity| entity.attributes[key] == value }
          end
          pool
        end
      end
    end
  end
end
