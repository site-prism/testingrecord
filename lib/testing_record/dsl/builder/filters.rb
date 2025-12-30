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
          !find_by(attributes).nil?
        end

        # Finds an entity with the provided email address
        #   If one is found, set it as the current entity
        #
        # @return [TestingRecord::Model, nil]
        def with_email(email_address)
          find_by({ email_address: })&.tap { |entity| self.class.current = entity }
        end

        private

        # Finds an entity by matching attribute values
        #
        # @return [TestingRecord::Model, nil]
        def find_by(attributes)
          pool = all
          attributes.each do |key, value|
            # TODO: Enable this logging once v0.5 is released with logger support
            # AutomationLogger.debug("Current user pool size: #{pool.length}")
            # AutomationLogger.debug("Filtering User list by #{key}: #{value}")
            pool = pool.select { |entity| entity.attributes[key] == value }
          end
          pool.first
        end
      end
    end
  end
end
