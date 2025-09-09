# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Helpers do
  subject(:instance) { klazz.new }

  describe '.add_helpers' do
    context 'with a default property' do
      let(:klazz) do
        Class.new(TestingRecord::Model) do
          property :foo
          add_helpers
        end
      end

      it 'will add the #any? helper to the singular property of the model' do
        expect(instance).to respond_to(:foo?)
      end
    end

    context 'with a singular property' do
      let(:klazz) do
        Class.new(TestingRecord::Model) do
          property :bar, type: :singular
          add_helpers
        end
      end

      it 'will add the #any? helper to the singular property of the model' do
        expect(instance).to respond_to(:bar?)
      end
    end

    context 'with a plural property' do
      let(:klazz) do
        Class.new(TestingRecord::Model) do
          property :baz, type: :plural
          add_helpers
        end
      end

      it 'will add the #any? helper to the plural property of the model' do
        expect(instance).to respond_to(:bazs?)
      end
    end
  end

  describe '.add_any_helper' do
    let(:klazz) do
      Class.new do
        extend TestingRecord::DSL::Builder::Helpers
      end
    end

    before { klazz.add_any_helper(:foo) }

    it 'creates a boolean helper with the desired name' do
      expect(instance).to respond_to(:foo?)
    end

    it 'is `true` when the iVar corresponding to the name is not empty' do
      instance.instance_variable_set(:@foo, [1])

      expect(instance.foo?).to be true
    end

    it 'is `false` when the iVar corresponding to the name is empty' do
      instance.instance_variable_set(:@foo, [])

      expect(instance.foo?).to be false
    end
  end
end
