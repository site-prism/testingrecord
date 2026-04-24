# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Settings do
  subject(:klazz) do
    Class.new do
      extend TestingRecord::DSL::Builder::Settings
    end
  end

  describe '.caching' do
    context 'when enabling caching' do
      before do
        stub_const('FakeModel', Class.new(klazz))
        FakeModel.caching :enabled
      end

      it 'automatically creates the cache as an empty array' do
        expect(FakeModel.all).to eq([])
      end
    end

    context 'without caching enabled' do
      before do
        stub_const('FakeModel', Class.new(klazz))
        FakeModel.caching :disabled
      end

      it 'does not generate a cache' do
        expect(FakeModel).not_to respond_to(:all)
      end
    end

    context 'with an invalid caching setting' do
      before do
        stub_const('FakeModel', Class.new(klazz))
      end

      it 'cannot be configured on the model' do
        expect { FakeModel.caching :invalid }.to raise_error(TestingRecord::Error::InvalidConfigurationError)
      end
    end
  end

  describe '.primary_key' do
    subject(:refined_class) do
      Class.new(klazz) do
        primary_key :baz
      end
    end

    it 'stores the primary key on the model' do
      expect(refined_class.__primary_key).to eq(:baz)
    end
  end
end
