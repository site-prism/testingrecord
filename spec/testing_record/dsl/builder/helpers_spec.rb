# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Helpers do
  subject(:instance) { klazz.new }

  describe '.add_helpers' do
    let(:list_of_helpers) { [:any] }
    let(:klazz) do
      Class.new(TestingRecord::Model) do
        property :foo
        property :bar, type: :singular
        property :baz, type: :plural
      end
    end

    before { klazz.add_helpers }

    it 'will add each helper to the model, for all of the relevant properties' do
      expect(instance).to respond_to(:foo?).and respond_to(:bar?).and respond_to(:bazs?)
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
