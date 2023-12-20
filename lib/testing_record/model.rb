# frozen_string_literal: true

module TestingRecord
  # The top level Model. Most of the behaviours specified here are fairly rudimentary ones that will then
  # include other behaviour(s), from the included modules
  class Model
    class << self
      # Set the type of model, this should be one of `:singular` or `:plural`
      #
      # @return [Symbol]
      def type(type)
        @type = type
      end
    end
  end
end
