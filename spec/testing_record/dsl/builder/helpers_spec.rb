# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Helpers do
  subject(:instance) { klazz.new }
  let(:klazz) do
    Class.new(TestingRecord::Model) do
      attribute :foo
      add_helpers
    end
  end

  describe '.add_helpers' do
    context 'adds the presence helper to check if an attribute is present' do
      it 'is true for defined strings' do
        expect(klazz.create({ foo: 'bar' }).foo?).to be true
      end

      it 'is true for defined symbols' do
        expect(klazz.create({ foo: :bar }).foo?).to be true
      end

      it 'is true for defined non-empty arrays' do
        expect(klazz.create({ foo: ['abc'] }).foo?).to be true
      end

      it 'is false for defined nil values' do
        expect(klazz.create({ foo: nil }).foo?).to be false
      end

      it 'is false for defined empty arrays' do
        expect(klazz.create({ foo: [] }).foo?).to be false
      end

      it 'is false for defined empty hashes' do
        expect(klazz.create({ foo: {} }).foo?).to be false
      end

      it 'does not work undefined for undefined attributes' do
        expect(klazz.create({ bar: 'value' })).not_to respond_to(:bar?)
      end
    end
  end
end
