# frozen_string_literal: true

module TestingRecord
  module DSL
    module Validation
      # [TestingRecord::DSL::Validation::Input]
      # Validations for direct inputs into creating models
      module Input
        # Check whether the caching setting is valid
        #
        # @return [Boolean]
        def caching_valid?(input)
          caching_validations.include?(input)
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
