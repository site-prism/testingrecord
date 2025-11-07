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
          enabled_or_disabled.include?(input)
        end

        # Check whether the type setting is valid
        #
        # @return [Boolean]
        def type_valid?(input)
          singular_or_plural.include?(input)
        end

        private

        def enabled_or_disabled = %i[enabled disabled]
        def singular_or_plural = %i[singular plural]
      end
    end
  end
end
