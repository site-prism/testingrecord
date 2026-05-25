# frozen_string_literal: true

# Must be loaded before builder as some validations are needed during build phase
require_relative 'dsl/validation'

require_relative 'dsl/builder'
