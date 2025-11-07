# frozen_string_literal: true

require 'automation_helpers/extensions/string'
require_relative 'dsl'

module TestingRecord
  # The top level Model. Most of the behaviours specified here are fairly rudimentary ones that will then
  # include other behaviour(s), from the included modules
  class Model
    extend DSL::Builder::Helpers
    extend DSL::Builder::Settings

    attr_reader :attributes

    def initialize(attributes = {})
      @attributes = attributes
    end
  end
end
