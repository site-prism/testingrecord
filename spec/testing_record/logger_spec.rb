# frozen_string_literal: true

describe TestingRecord::Logger do
  describe '#create' do
    subject(:logger) { described_class.create }

    it { is_expected.to be_a Logger }

    it 'has a default name' do
      expect(logger.progname).to eq('Testing Record')
    end

    it 'logs at DEBUG level by default' do
      expect(logger.level).to eq(0)
    end
  end
end
