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
            entity.class.attr_reader attribute_key
          end

          break entity unless respond_to?(:all)

          self.current = entity
          all << entity
          TestingRecord.logger.debug("Entity: #{entity} added to cache")
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

    # View the entity in question in a readable format. Displays all iVars and their values (Primary Key first if set)
    #
    # @return [String]
    def inspect
      reorder_attributes_for_inspect!
      "#<#{self.class.name} #{attributes.map { |k, v| "@#{k}=#{v.inspect}" }.join(', ')}>"
    end

    # Functionally equivalent to `inspect`
    #
    # @return [String]
    def to_s
      inspect
    end

    # Updates an entity (instance), of a model
    #   -> Updating iVar values for each attribute that was provided
    #   -> It will **not** create new reader methods for new variables added
    #
    # @return [TestingRecord::Model]
    def update(attrs)
      old_entity = self
      attrs.each do |key, value|
        attributes[key] = value
        instance_variable_set("@#{key}", value)
        TestingRecord.logger.info("Updated '#{key}' on current #{self.class} entity to be '#{value}'")
      end

      return self unless self.class.respond_to?(:all)

      self.class.all << self
      self.class.delete(old_entity)
      self
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
