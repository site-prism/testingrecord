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

        # Finds all entities that match specified attribute values
        #   attributes (Hash) -> The attributes you wish to filter on, each is iterated through sequentially
        #   :logic (Symbol) -> Whether to use `AND` or `OR` logic to combine each sequential key in attributes hash
        #
        # @return [Array<TestingRecord::Model>]
        def find_by(attributes, logic: :AND)
          TestingRecord.logger.debug("Filtering Entity: '#{self}' list by #{attributes}. Logic: '#{logic}'")
          if logic == :OR
            all.select do |entity|
              attributes.any? { |key, value| entity.attributes.key?(key) && entity.attributes.fetch(key) == value }
            end
          else
            all.select do |entity|
              attributes.all? { |key, value| entity.attributes.fetch(key) == value }
            end
          end
        end

        # Finds an entity with the provided email address
        #   If one is found, set it as the current entity
        #
        # @return [TestingRecord::Model, nil]
        def with_email(email_address)
          email_address_results =
            find_by({ email_address: }).first ||
            find_by({ email: email_address }).first ||
            find_by({ 'email-address': email_address }).first

          email_address_results&.tap { |entity| entity.class.current = entity }
        end

        # Checks to see whether an entity exists with the provided id
        #
        # @return [Boolean]
        def with_id?(id)
          !with_id(id).nil?
        end

        # Finds an entity with the provided id
        #   If one is found, set it as the current entity
        #
        # @return [TestingRecord::Model, nil]
        def with_id(id)
          find_by({ id: })&.first&.tap { |entity| entity.class.current = entity }
        end

        # Checks to see whether an entity exists with the provided primary_key
        #
        # @return [Boolean]
        def with_primary_key?(primary_key)
          !with_primary_key(primary_key).nil?
        end

        # Finds an entity with the provided primary_key
        #   If one is found, set it as the current entity
        #
        # @return [TestingRecord::Model, nil]
        def with_primary_key(primary_key)
          find_by({ __primary_key => primary_key })&.first&.tap { |entity| entity.class.current = entity }
        end
      end
    end
  end
end
