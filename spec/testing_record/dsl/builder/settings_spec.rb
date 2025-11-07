# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Settings do
  subject(:klazz) do
    Class.new do
      extend TestingRecord::DSL::Builder::Settings

      def initialize(attributes = {})
        @attributes = attributes
      end
    end
  end

  describe '.caching' do
    before do
      stub_const('SettingsTest', Class.new(klazz))
      SettingsTest.caching :enabled
    end

    it 'generates a new reader class method for accessing the raw data' do
      expect(SettingsTest).to respond_to(:settings_tests)
    end

    it 'automatically creates the cache as an empty array' do
      expect(SettingsTest.settings_tests).to eq([])
    end
  end

  describe '.create' do
    context 'with caching enabled' do
      before do
        stub_const('SettingsTest', Class.new(klazz))
        SettingsTest.caching :enabled
      end

      it 'generates a new instance of the model entity' do
        expect(SettingsTest.create).to be_a SettingsTest
      end

      it 'adds the entity to the cache' do
        expect { SettingsTest.create }.to change(SettingsTest.settings_tests, :length).by(1)
      end
    end

    context 'without caching enabled' do
      before do
        stub_const('SettingsTest', Class.new(klazz))
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
        stub_const('SettingsTest', Class.new(klazz))
      end

      it 'cannot be configured on the model' do
        expect { SettingsTest.caching :invalid }.to raise_error(TestingRecord::Error)
      end
    end
  end

  describe '.property' do
    context 'when not classified' do
      let(:refined_class) do
        Class.new(klazz) do
          property :bar
        end
      end

      it 'sets the property as a method on the model instance' do
        expect(refined_class.create).to respond_to(:bar)
      end

      it 'stores the property as a singular type on the model' do
        expect(refined_class.properties).to include({ name: :bar, type: :singular })
      end
    end

    context 'when classified as singular' do
      let(:refined_class) do
        Class.new(klazz) do
          property :bar, type: :singular
        end
      end

      it 'sets the property as a method on the model instance' do
        expect(refined_class.create).to respond_to(:bar)
      end

      it 'stores the property as a singular type on the model' do
        expect(refined_class.properties).to include({ name: :bar, type: :singular })
      end
    end

    context 'when classified as plural' do
      let(:refined_class) do
        Class.new(klazz) do
          property :bar, type: :plural
        end
      end

      it 'sets the property as a method on the model instance' do
        expect(refined_class.create).to respond_to(:bars)
      end

      it 'stores the property as a singular type on the model' do
        expect(refined_class.properties).to include({ name: :bar, type: :plural })
      end
    end

    context 'with an invalid type setting' do
      before do
        stub_const('SettingsTest', Class.new(klazz))
      end

      it 'cannot be configured on the model' do
        expect { SettingsTest.property :bar, type: :invalid }.to raise_error(TestingRecord::Error)
      end
    end
  end

  describe '.type' do
    context 'when classified as a singular model' do
      let(:refined_class) do
        Class.new(klazz) do
          type :singular
        end
      end

      it 'sets the singular model properties' do
        expect(refined_class.instance_variable_get(:@type)).to eq(:singular)
      end
    end

    context 'when classified as a plural model' do
      let(:refined_class) do
        Class.new(klazz) do
          type :plural
        end
      end

      it 'sets the plural model properties' do
        expect(refined_class.instance_variable_get(:@type)).to eq(:plural)
      end
    end

    context 'with an invalid type setting' do
      before do
        stub_const('SettingsTest', Class.new(klazz))
      end

      it 'cannot be configured on the model' do
        expect { SettingsTest.type :invalid }.to raise_error(TestingRecord::Error)
      end
    end
  end
end
