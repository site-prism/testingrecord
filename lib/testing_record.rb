# frozen_string_literal: true

require_relative 'testing_record/dsl'
require_relative 'testing_record/error'
require_relative 'testing_record/logger'
require_relative 'testing_record/model'
require_relative 'testing_record/version'

# {TestingRecord} namespace
module TestingRecord
  class << self
    attr_reader :default_primary_key

    def configure
      yield self
    end

    # Configure a default primary key for all TestingRecord models
    def default_primary_key=(value)
      @default_primary_key = value
      TestingRecord::Model.primary_key value
    end

    # Specify the default primary key to `:id` (This is procedural so will be overwritten at runtime if config defined)
    TestingRecord.default_primary_key = :id

    # The Testing Record logger object - This is called automatically in several
    # locations and will log messages according to the normal Ruby protocol
    #
    # This logger object can also be used to manually log messages
    #
    # To Manually log a message
    #   TestingRecord.logger.info('Information')
    #   TestingRecord.logger.debug('Input debug message')
    #
    # By default the logger will output all messages to $stdout, but can be
    # altered to log to a file or another IO location by calling `.log_path=`
    def logger
      @logger ||= Logger.create
    end

    # This writer method allows you to configure where you want the testingrecord logs to be sent to (Default is $stdout)
    #
    #   Example: TestingRecord.log_path = 'testingrecord.log' would save all log messages to `./testingrecord.log`
    def log_path=(logdev)
      logger.reopen(logdev)
    end

    # To enable full logging (This uses the Ruby API, so can accept any of a
    # Symbol / String / Integer as an input
    #   TestingRecord.log_level = :DEBUG
    #   TestingRecord.log_level = 'DEBUG'
    #   TestingRecord.log_level = 0
    #
    # To disable all logging
    #   TestingRecord.log_level = :UNKNOWN
    def log_level=(value)
      logger.level = value
    end

    # To query what level is being logged
    #   TestingRecord.log_level # => :DEBUG # By default
    def log_level
      %i[DEBUG INFO WARN ERROR FATAL UNKNOWN][logger.level]
    end
  end
end
