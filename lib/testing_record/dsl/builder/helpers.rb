# frozen_string_literal: true

module TestingRecord
  module DSL
    module Builder
      # [TestingRecord::DSL::Builder::Helpers]
      # Ways in which we can build in extra helper methods from building requests
      module Helpers
        # Method to add all helpers - Should be called last in the DSL invocations in the class definition
        #
        # @return [TestingRecord::Model]
        def add_helpers
          properties.each do |property|
            if property[:type] == :singular
              add_any_helper(property[:name])
            else
              add_any_helper("#{property[:name]}s")
            end
          end
        end

        private

        # Add the boolean helper which will perform the `#any?` check on your instance
        #
        # @return [TestingRecord::Model]
        def add_any_helper(name)
          define_method(:"#{name}?") do
            instance_variable_get(:"@#{name}").any?
          end
        end
      end
    end
  end
end
