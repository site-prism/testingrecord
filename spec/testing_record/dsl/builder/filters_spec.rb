# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Filters do
  subject(:filter_klazz) do
    Class.new do
      extend TestingRecord::DSL::Builder::Filters
    end
  end

  let(:models) { [model.new, model.new] }
  let(:model) { Class.new(TestingRecord::Model) }

  describe '.exists?' do
    context 'when entity does not exist' do
      before do
        allow(filter_klazz).to receive(:find_by).and_return(nil)
      end

      it 'is `false`' do
        expect(filter_klazz.exists?(name: 'Test')).to be false
      end
    end

    context 'when entity exists' do
      before do
        allow(filter_klazz).to receive(:find_by).and_return(models)
      end

      it 'is `true`' do
        expect(filter_klazz.exists?(name: 'Test')).to be true
      end
    end
  end

  describe '.with_email' do
    context 'when entity does not exist' do
      before do
        allow(filter_klazz).to receive(:find_by).and_return(nil)
      end

      it 'does not find a model' do
        expect(model_klazz.with_email('foo@bar.com')).to eq(1)
      end
    end

    context 'when entity exists' do
      before do
        allow(filter_klazz).to receive(:find_by).and_return(models)
      end

      it 'finds the first matching model' do
        expect(model_klazz.with_email('foo@bar.com')).to eq(1)
      end
    end
  end
end
