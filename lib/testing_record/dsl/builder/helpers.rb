# frozen_string_literal: true

module TestingRecord
  module DSL
    module Builder
      # [TestingRecord::DSL::Builder::Helpers]
      # Ways in which we can build in extra helper methods from building requests
      module Helpers
        # Method to add all helpers
        #
        # @return [TestingRecord::Model]
        def add_helpers
          
        end

        # Add the boolean helper which will perform the `#any?` check on your instance
        #
        # @return [TestingRecord::Model]
        def add_any_helper(name)
          define_method(:"#{name}?") do
            instance_variable_get(:"@#{name}").any?
          end
        end

        # Check whether the type setting is valid
        #
        # @return [Boolean]
        def type_valid?(input)
          type_validations.include?(input)
        end

        private

        def caching_validations = %i[enabled disabled]
        def type_validations = %i[singular plural]
      end
    end
  end
end
