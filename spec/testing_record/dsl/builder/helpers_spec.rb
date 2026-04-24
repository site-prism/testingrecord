# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Helpers do
  subject(:klazz) do
    Class.new(TestingRecord::Model) do
      include_helpers
      primary_key :foo
    end
  end

  describe '.include_helpers' do
    it 'adds the presence helper (true), for defined strings' do
      expect(klazz.create({ foo: 'bar' }).foo?).to be true
    end

    it 'adds the presence helper (true), for defined symbols' do
      expect(klazz.create({ foo: :bar }).foo?).to be true
    end

    it 'adds the presence helper (true), for defined non-empty arrays' do
      expect(klazz.create({ foo: ['abc'] }).foo?).to be true
    end

    it 'adds the presence helper (false), for defined nil values' do
      expect(klazz.create({ foo: nil }).foo?).to be false
    end

    it 'adds the presence helper (false), for defined empty arrays' do
      expect(klazz.create({ foo: [] }).foo?).to be false
    end

    it 'adds the presence helper (false), for defined empty hashes' do
      expect(klazz.create({ foo: {} }).foo?).to be false
    end
  end
end
