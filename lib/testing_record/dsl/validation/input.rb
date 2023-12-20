# frozen_string_literal: true

module TestingRecord
  module DSL
    module Validation
      # [TestingRecord::DSL::Validation::Input]
      # Validations for direct inputs into creating models
      module Input
        def type_valid?(input)
          type_validations.include?(input)
        end

        private

        def type_validations = %i[singular plural]
      end
    end
  end
end
