# frozen_string_literal: true

require 'fileutils'

describe TestingRecord do
  # Stop the $stdout process leaking cross-tests
  before { wipe_logger! }

  describe '.logger' do
    it 'logs messages at every level by default' do
      log_messages = capture_stdout do
        described_class.logger.debug('DEBUG')
        described_class.logger.unknown('UNKNOWN')
      end

      expect(lines(log_messages)).to eq(2)
    end
  end

  describe '.log_path=' do
    context 'when set to a file' do
      let(:filename) { 'sample.log' }
      let(:file_content) { File.read(filename) }

      before { described_class.log_path = filename }

      after { FileUtils.rm_f(filename)  }

      it 'sends the log messages to the file-path provided' do
        described_class.logger.unknown('This is sent to the file')

        expect(file_content).to end_with("This is sent to the file\n")
      end
    end

    context 'when set to $stderr' do
      it 'sends the log messages to $stderr' do
        expect do
          described_class.log_path = $stderr
          described_class.logger.unknown('This is sent to $stderr')
        end.to output(/This is sent to \$stderr/).to_stderr
      end
    end
  end
end
