# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Helpers do
  subject(:instance) { klazz.new }

  describe '.add_helpers' do
    context 'with a default attribute' do
      let(:klazz) do
        Class.new(TestingRecord::Model) do
          attribute :foo
          add_helpers
        end
      end

      context 'adds the presence helper to check if the attribute in question is present' do
        it 'is true for strings' do
          expect(klazz.create({ foo: 'bar' }).foo?).to be true
        end

        it 'is true for symbols' do
          expect(klazz.create({ foo: :bar }).foo?).to be true
        end

        it 'is true for non-empty arrays' do
          expect(klazz.create({ foo: ['abc'] }).foo?).to be true
        end

        it 'is false for nil values' do
          expect(klazz.create({ foo: nil }).foo?).to be false
        end

        it 'is false for empty arrays' do
          expect(klazz.create({ foo: [] }).foo?).to be false
        end

        it 'is false for empty hashes' do
          expect(klazz.create({ foo: {} }).foo?).to be false
        end
      end
    end
  end
end
