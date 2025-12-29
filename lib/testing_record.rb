# frozen_string_literal: true

require_relative 'testing_record/dsl'
require_relative 'testing_record/logger'
require_relative 'testing_record/model'
require_relative 'testing_record/version'

# {TestingRecord} namespace
module TestingRecord
  # Generic TestingRecord error. Will be extended in the future
  class Error < StandardError; end

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
end
