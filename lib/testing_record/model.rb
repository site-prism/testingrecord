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
      #   -> Creating iVar values for each attribute that was provided
      #   -> Adding it to the cache if caching is enabled
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

      # Deletes the instance of the model from the cache (Does nothing if caching is disabled)
      #
      # @return [TestingRecord::Model]
      def delete(entity)
        all.delete(entity) if respond_to?(:all)
      end
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    def inspect
      reorder_attributes_for_inspect!
      "#<#{self.class.name} #{attributes.map { |k, v| "@#{k}=#{v.inspect}" }.join(', ')}>"
    end

    def to_s
      inspect
    end

    def update(attrs)
      attrs.each do |key, value|
        attributes[key] = value
        instance_variable_set("@#{key}", value)
        TestingRecord.logger.info("Updated '#{key}' on current #{self.class} entity to be '#{value}'")
      end
      # This is calling a private method on the class, but we want to do this here
      self.class.send(:update_cache, self) if respond_to?(:all)
    end

    private

    def reorder_attributes_for_inspect!
      return unless self.class.__primary_key
      return if attributes.keys.first == self.class.__primary_key

      pk_value = attributes.delete(self.class.__primary_key)
      @attributes = { self.class.__primary_key => pk_value }.merge(attributes)
    end
  end
end
