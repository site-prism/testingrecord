# frozen_string_literal: true

module TestingRecord
  module Error
    class AttributeError < StandardError; end
    class EntityError < StandardError; end
    class InvalidConfigurationError < StandardError; end
  end
end
