# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Helpers do
  subject(:klazz) do
    Class.new do
      extend TestingRecord::DSL::Builder::Helpers
    end
  end

  describe '.add_any_helper' do
    subject(:instance) { klazz.new }

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
