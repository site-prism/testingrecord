# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Validation::Input do
  subject(:klazz) do
    Class.new do
      extend TestingRecord::DSL::Validation::Input
    end
  end

  describe '.caching_valid?' do
    it 'is `true` when the type is :enabled' do
      expect(klazz.caching_valid?(:enabled)).to be true
    end

    it 'is `true` when the type is :disabled' do
      expect(klazz.caching_valid?(:disabled)).to be true
    end

    it 'is `false` for all other types' do
      expect(klazz.caching_valid?(:foo)).to be false
    end
  end

  describe '.filter_logic_valid??' do
    it 'is `true` when the type is :and' do
      expect(klazz.filter_logic_valid?(:and)).to be true
    end

    it 'is `true` when the type is :or' do
      expect(klazz.filter_logic_valid?(:or)).to be true
    end

    it 'is `false` for all other types' do
      expect(klazz.filter_logic_valid?(:foo)).to be false
    end
  end
end
