# frozen_string_literal: true

require 'logger'

module TestingRecord
  #
  # @api private
  #
  class Logger
    #
    # Generate the Logger used in the gem
    #
    def self.create(output = $stdout)
      logger = ::Logger.new(output)
      logger.progname = 'Testing Record'
      logger.level = :DEBUG
      logger.formatter = proc do |severity, time, progname, msg|
        "#{time.strftime('%F %T')} - #{severity} - #{progname} - #{msg}\n"
      end

      logger
    end
  end
end
