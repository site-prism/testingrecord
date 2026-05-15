# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Filters do
  subject(:model_klazz) do
    Class.new(TestingRecord::Model) do
      caching :enabled
      primary_key :email_address
    end
  end

  before { silence_logger! }

  describe '.exists?' do
    context 'when entity does not exist' do
      it 'is `false`' do
        expect(model_klazz.exists?({ email_address: 'foo@bar.com' })).to be false
      end
    end

    context 'when entity exists' do
      before do
        model_klazz.create({ email_address: 'foo@bar.com' })
        model_klazz.create({ email_address: 'baz@bar.com' })
      end

      it 'is `true`' do
        expect(model_klazz.exists?({ email_address: 'foo@bar.com' })).to be true
      end
    end
  end

  describe '.with_email' do
    context 'when entity does not exist' do
      it 'does not find a model' do
        expect(model_klazz.with_email('foo@bar.com')).to be_nil
      end
    end

    context 'when entity exists' do
      before do
        model_klazz.create({ email_address: 'foo@bar.com' })
        model_klazz.create({ email_address: 'baz@bar.com' })
      end

      it 'finds the first matching model' do
        expect(model_klazz.with_email('foo@bar.com')).to be_a TestingRecord::Model
      end
    end
  end

  describe '.find_by' do
    let(:foo_entity) { model_klazz.create({ email_address: 'foo@foo.com', foo: 3, other: :foo }) }
    let(:bar_entity) { model_klazz.create({ email_address: 'bar@bar.com', foo: 3, other: :bar }) }
    let(:baz_entity) { model_klazz.create({ email_address: 'baz@baz.com', foo: 3, other: :baz }) }

    before do
      foo_entity
      bar_entity
      baz_entity
    end

    context 'with a simple 1 attribute query' do
      it 'returns a collection of entities that match the query' do
        expect(model_klazz.find_by({ foo: 3 })).to eq([foo_entity, bar_entity, baz_entity])
      end

      it 'returns a blank collection when no entities match the query' do
        expect(model_klazz.find_by({ foo: 4 })).to eq([])
      end
    end

    context 'with a more complex set of attributes as a query' do
      it 'returns a collection of entities that match all query attributes' do
        expect(model_klazz.find_by({ foo: 3, other: :foo })).to eq([foo_entity])
      end

      it 'returns a blank collection when no entities match all query attributes' do
        expect(model_klazz.find_by({ foo: 3, other: :jeff })).to eq([])
      end
    end
  end

  describe '.with_id' do
    before { model_klazz.primary_key :id }
    after { model_klazz.primary_key :email_address }

    context 'when entity does not exist' do
      it 'does not find a model' do
        expect(model_klazz.with_id(1)).to be_nil
      end
    end

    context 'when entity exists' do
      before do
        model_klazz.create({ id: 1 })
        model_klazz.create({ id: 2 })
      end

      it 'finds the first matching model' do
        expect(model_klazz.with_id(1)).to be_a TestingRecord::Model
      end
    end
  end

  describe '.with_id?' do
    before { model_klazz.primary_key :id }
    after { model_klazz.primary_key :email_address }

    context 'when entity does not exist' do
      it 'is `false`' do
        expect(model_klazz.with_id?(1)).to be false
      end
    end

    context 'when entity exists' do
      before do
        model_klazz.create({ id: 1 })
        model_klazz.create({ id: 2 })
      end

      it 'is `true`' do
        expect(model_klazz.with_id?(1)).to be true
      end
    end
  end

  describe '.with_primary_key' do
    before { model_klazz.primary_key :peekay }
    after { model_klazz.primary_key :email_address }

    context 'when entity does not exist' do
      it 'does not find a model' do
        expect(model_klazz.with_primary_key(1)).to be_nil
      end
    end

    context 'when entity exists' do
      before do
        model_klazz.create({ peekay: 1 })
        model_klazz.create({ peekay: 2 })
      end

      it 'finds the first matching model' do
        expect(model_klazz.with_primary_key(1)).to be_a TestingRecord::Model
      end
    end
  end

  describe '.with_primary_key?' do
    before { model_klazz.primary_key :peekay }
    after { model_klazz.primary_key :email_address }

    context 'when entity does not exist' do
      it 'is `false`' do
        expect(model_klazz.with_primary_key?(1)).to be false
      end
    end

    context 'when entity exists' do
      before do
        model_klazz.create({ peekay: 1 })
        model_klazz.create({ peekay: 2 })
      end

      it 'is `true`' do
        expect(model_klazz.with_primary_key?(1)).to be true
      end
    end
  end
end
