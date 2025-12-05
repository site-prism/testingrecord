# frozen_string_literal: true

RSpec.describe TestingRecord::Model do
  describe '.create' do
    subject(:instance) { refined_class.create }

    let(:refined_class) do
      Class.new(described_class) do
        attribute :bar, type: :singular
        attribute :baz, type: :plural
        attribute :bay
      end
    end

    context 'with caching enabled' do
      before do
        stub_const('SettingsTest', Class.new(described_class))
        SettingsTest.caching :enabled
      end

      it 'generates a new instance of the model entity' do
        expect(SettingsTest.create).to be_a SettingsTest
      end

      it 'adds the entity to the cache' do
        expect { SettingsTest.create }.to change(SettingsTest.settings_tests, :length).by(1)
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
        expect(SettingsTest).not_to respond_to(:SettingsTests)
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

    it 'stores the default value of singular attributes as an empty string' do
      expect(instance.bar).to eq('')
    end

    it 'stores the default value of plural attributes as an empty array' do
      expect(instance.baz).to eq([])
    end

    it 'stores the default value of attributes as an empty string (singular default)' do
      expect(instance.bay).to eq('')
    end
  end
end
