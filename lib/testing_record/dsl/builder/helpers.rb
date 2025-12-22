# frozen_string_literal: true

module TestingRecord
  module DSL
    module Builder
      # [TestingRecord::DSL::Builder::Helpers]
      # Ways in which we can build in extra helper methods from building requests
      module Helpers
        # Method to add all helpers - Should be called last in the DSL invocations in the class definition
        #
        # @return [Array]
        def add_helpers
          attributes.each do |attribute|
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
