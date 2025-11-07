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

  describe '.property' do
    let(:instance) { refined_class.create }

    context 'when not classified' do
      let(:refined_class) do
        Class.new(klazz) do
          property :bar
        end
      end

      it 'sets the property as a method on the model instance' do
        expect(instance).to respond_to(:bar)
      end

      it 'stores the property as a singular type on the model' do
        expect(refined_class.properties).to include({ name: :bar, type: :singular })
      end

      it 'stores the default property value as `nil` (singular default)' do
        expect(instance.bar).to be_nil
      end
    end

    context 'when classified as singular' do
      let(:refined_class) do
        Class.new(klazz) do
          property :bar, type: :singular
        end
      end

      it 'sets the property as a method on the model instance' do
        expect(instance).to respond_to(:bar)
      end

      it 'stores the property as a singular type on the model' do
        expect(refined_class.properties).to include({ name: :bar, type: :singular })
      end

      it 'stores the default property value as `nil`' do
        expect(instance.bar).to be_nil
      end
    end

    context 'when classified as plural' do
      let(:refined_class) do
        Class.new(klazz) do
          property :bar, type: :plural
        end
      end

      it 'sets the property as a method on the model instance' do
        expect(instance).to respond_to(:bars)
      end

      it 'stores the property as a singular type on the model' do
        expect(refined_class.properties).to include({ name: :bar, type: :plural })
      end

      it 'stores the default property value as an empty array' do
        expect(instance.bars).to eq([])
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
