# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Validation::Input do
  subject(:klazz) do
    Class.new do
      extend TestingRecord::DSL::Validation::Input
    end
  end

  describe '#caching_valid?' do
    it 'is `true` when the type is enabled' do
      expect(klazz.caching_valid?(:enabled)).to be true
    end

    it 'is `true` when the type is disabled' do
      expect(klazz.caching_valid?(:disabled)).to be true
    end

    it 'is `false` for all other types' do
      expect(klazz.caching_valid?(:foo)).to be false
    end
  end

  describe '#type_valid?' do
    it 'is `true` when the type is singular' do
      expect(klazz.type_valid?(:singular)).to be true
    end

    it 'is `true` when the type is plural' do
      expect(klazz.type_valid?(:plural)).to be true
    end

    it 'is `false` for all other types' do
      expect(klazz.type_valid?(:foo)).to be false
    end
  end
end
