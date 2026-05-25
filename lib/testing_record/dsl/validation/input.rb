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
          %i[enabled disabled].include?(input)
        end

        def filter_logic_valid?(input)
          %i[and or].include?(input)
        end
      end
    end
  end
end
