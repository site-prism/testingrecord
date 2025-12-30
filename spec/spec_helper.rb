# frozen_string_literal: true

require 'testing_record'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include SpecSupport::Console

  config.example_status_persistence_file_path = '.rspec_status'

  def wipe_logger!
    return unless TestingRecord.instance_variable_get(:@logger)

    TestingRecord.remove_instance_variable(:@logger)
  end
end
