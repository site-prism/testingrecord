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
      expect(SettingsTest).to respond_to(:all)
    end

    it 'automatically creates the cache as an empty array' do
      expect(SettingsTest.all).to eq([])
    end
  end

  describe '.attribute' do
    let(:instance) { refined_class.new }

    context 'when not classified' do
      let(:refined_class) do
        Class.new(klazz) do
          attribute :bar
        end
      end

      it 'sets the attribute as a method on the model instance' do
        expect(instance).to respond_to(:bar)
      end

      it 'stores the attribute' do
        expect(refined_class.attributes).to include(:bar)
      end
    end
  end
end
