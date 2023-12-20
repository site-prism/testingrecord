# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Validation::Input do
  subject(:klazz) do
    Class.new do
      extend TestingRecord::DSL::Validation::Input
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
