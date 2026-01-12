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
    end
  end

  describe '.attributes' do
    context 'when not classified' do
      let(:refined_class) do
        Class.new(klazz) do
          attribute :bar
        end
      end

      it 'stores all configured attributes' do
        expect(refined_class.attributes).to include(:bar)
      end
    end
  end

  describe '.caching' do
    before do
      stub_const('FakeModel', Class.new(klazz))
      FakeModel.caching :enabled
    end

    it 'generates a new reader class method for accessing the raw data' do
      expect(FakeModel).to respond_to(:all)
    end

    it 'automatically creates the cache as an empty array' do
      expect(FakeModel.all).to eq([])
    end
  end

  describe '.primary_key' do
    let(:refined_class) do
      Class.new(klazz) do
        primary_key :id
      end
    end

    it 'stores a primary key value' do
      expect(refined_class.__primary_key).to eq(:id)
    end
  end
end
