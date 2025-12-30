# frozen_string_literal: true

require 'automation_helpers/extensions/string'
require_relative 'dsl'

module TestingRecord
  # The top level Model. Most of the behaviours specified here are fairly rudimentary ones that will then
  # include other behaviour(s), from the included modules
  class Model
    extend DSL::Builder::Filters
    extend DSL::Builder::Helpers
    extend DSL::Builder::Settings

    attr_reader :attributes

    class << self
      attr_accessor :current

      # Creates an instance of the model
      #   -> Adding it to the cache if caching is enabled
      #   -> Creating iVar values for each attribute that was provided
      #
      # @return [TestingRecord::Model]
      def create(attributes = self.attributes)
        new(attributes).tap do |entity|
          attributes.each do |attribute_key, attribute_value|
            entity.instance_variable_set("@#{attribute_key}", attribute_value)
            attr_reader attribute_key
          end
          add_to_cache(entity) if respond_to?(:all)
        end
      end
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    def inspect
      "#<#{self.class.name} #{attributes.map { |k, v| "@#{k}=#{v.inspect}" }.join(', ')}>"
    end

    def to_s
      inspect
    end

    def update(attrs)
      attrs.each do |key, value|
        # TODO: Once logger is implemented this needs modifying to output a log message
        # AutomationLogger.debug("Updating '#{key}' on current User to be '#{value}'")
        attributes[key] = value
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
