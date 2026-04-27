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
      attr_reader :current

      # Creates an instance of the model
      #   -> Ensures that the primary key is specified in the attribute payload
      #   -> Validates that a duplicate entity has not been made (If caching is enabled)
      #   -> Creates iVar values (Symbol format) and attr_reader's for each attribute that was provided
      #   -> Adds helper methods (If the model has been configured to include helpers)
      #   -> Adds it to the cache (If caching is enabled)
      #
      # @return [TestingRecord::Model]
      def create(attributes)
        if respond_to?(:all)
          create_with_caching(attributes)
        else
          create_without_caching(attributes)
        end
      end

      # Sets the current entity instance to the one supplied (Or removes it if supplied `nil`)
      #
      # @return [TestingRecord::Model, nil]
      def current=(entity)
        if entity
          TestingRecord.logger.info("Switching current user from #{@current} to #{entity}")
        else
          TestingRecord.logger.info("Purging current user: #{@current}")
        end
        @current = entity
      end

      # Deletes the instance of the model from the cache (Does nothing if caching is disabled)
      #
      # @return [TestingRecord::Model, nil]
      def delete(entity)
        return unless respond_to?(:all)

        self.current = nil if entity == current
        all.delete(entity)
      end

      # Deletes the instance of the model from the cache (Does nothing if caching is disabled)
      #
      # @return [TestingRecord::Model, nil]
      def delete_by_id(id)
        delete(with_id(id)) if respond_to?(:all)
      end

      private

      def create_with_caching(attributes)
        ensure_primary_key_presence(attributes)
        ensure_deduplication(attributes)
        new(attributes.transform_keys(&:to_sym)).tap do |entity|
          configure_data(entity, attributes)
          add_helpers(attributes) if entity.class.instance_variable_get(:@include_helpers)
          cache_entity(entity)
        end
      end

      def create_without_caching(attributes)
        ensure_primary_key_presence(attributes)
        new(attributes.transform_keys(&:to_sym)).tap do |entity|
          configure_data(entity, attributes)
          add_helpers(attributes) if entity.class.instance_variable_get(:@include_helpers)
        end
      end

      def cache_entity(entity)
        self.current = entity
        all << entity
        TestingRecord.logger.debug("Entity: #{entity} added to cache")
      end

      def configure_data(entity, attributes)
        attributes.each do |attribute_key, attribute_value|
          entity.instance_variable_set("@#{attribute_key}", attribute_value)
          entity.class.attr_reader attribute_key
        end
      end

      def ensure_deduplication(attributes)
        pk_value = attributes[__primary_key]
        return unless with_primary_key?(pk_value)

        TestingRecord.logger.error("#{name} entity already exists with primary key: #{pk_value}")
        raise Error::AttributeError, "#{name} entity already exists with primary key: #{pk_value}"
      end

      def ensure_primary_key_presence(attributes)
        return if attributes.key?(__primary_key)

        raise Error::AttributeError, "#{name} entity has not been supplied with the primary key: #{__primary_key}"
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
    #   -> Updating iVar values for each attribute that was provided (Converting to symbolized format)
    #   -> It will **not** create new reader methods for new variables added
    #
    # @return [TestingRecord::Model]
    def update(attrs)
      attrs.transform_keys(&:to_sym).each do |key, value|
        attributes[key] = value
        instance_variable_set("@#{key}", value)
        TestingRecord.logger.info("Updated '#{key}' on the #{self.class} entity to be '#{value}'")
      end
      self
    end

    private

    def reorder_attributes_for_inspect!
      return if attributes.keys.first == self.class.__primary_key

      pk_value = attributes.delete(self.class.__primary_key)
      @attributes = { self.class.__primary_key => pk_value }.merge(attributes)
    end
  end
end
