# frozen_string_literal: true

module TestingRecord
  module DSL
    module Builder
      # [TestingRecord::DSL::Builder::Helpers]
      # Ways in which we can build in extra helper methods from building requests
      module Helpers
        # DSL signature to add all helpers - Should be procedurally called in the class definition
        def include_helpers
          @include_helpers = true
        end

        def add_helpers(attributes)
          attributes.each_key do |attribute|
            add_presence_helper(attribute)
          end
        end

        private

        # Add the boolean helper which will perform a check to determine whether...
        #   For singular / default categorisations, this checks if one has been set over the default empty value
        #   For plural attributes whether the array has any values
        #
        # @return [TestingRecord::Model]
        def add_presence_helper(name)
          define_method(:"#{name}?") do
            obj = send(name)
            !(obj.nil? || obj.empty?)
          end
        end
      end
    end
  end
end
