# frozen_string_literal: true

RSpec.describe TestingRecord::Model do
  let(:refined_class) do
    Class.new(described_class) do
      attribute :bar
      attribute :baz
      attribute :bay

      def self.name
        'TestingRecord::Model::Anonymous'
      end
    end
  end

  describe '.create' do
    subject(:instance) { refined_class.create }

    context 'with caching enabled' do
      before do
        stub_const('SettingsTest', Class.new(described_class))
        SettingsTest.caching :enabled
      end

      it 'generates a new instance of the model entity' do
        expect(SettingsTest.create).to be_a SettingsTest
      end

      it 'adds the entity to the cache' do
        expect { SettingsTest.create }.to change(SettingsTest.all, :length).by(1)
      end

      it 'updates the `.current` status to the newly created entity' do
        instance = SettingsTest.create

        expect(SettingsTest.current).to eq(instance)
      end
    end

    context 'without caching enabled' do
      before do
        stub_const('SettingsTest', Class.new(described_class))
        SettingsTest.caching :disabled
      end

      it 'generates a new instance of the model entity' do
        expect(SettingsTest.create).to be_a SettingsTest
      end

      it 'does not generate a cache add the entity to the cache' do
        expect(SettingsTest).not_to respond_to(:all)
      end
    end

    context 'with an invalid caching setting' do
      before do
        stub_const('SettingsTest', Class.new(described_class))
      end

      it 'cannot be configured on the model' do
        expect { SettingsTest.caching :invalid }.to raise_error(TestingRecord::Error)
      end
    end

    it 'does not store a default value of for attributes' do
      expect(instance.bar).to be_nil
    end
  end

  describe '#inspect' do
    subject(:instance) { refined_class.create({ bar: 'value1', baz: 42 }) }

    it 'returns a string representation of the model with its attributes' do
      expect(instance.inspect).to eq('#<TestingRecord::Model::Anonymous @bar="value1", @baz=42>')
    end
  end

  describe '#to_s' do
    subject(:instance) { refined_class.create({ bar: 'value1', baz: 42 }) }

    it 'returns the same string as #inspect' do
      expect(instance.to_s).to eq(instance.inspect)
    end
  end
end
