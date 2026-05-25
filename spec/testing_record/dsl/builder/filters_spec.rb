# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Filters do
  subject(:model_klazz) do
    Class.new(TestingRecord::Model) do
      caching :enabled
      primary_key :email_address

      def self.name
        'FakeModel'
      end
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

    context 'when entity exists with an `email_address` key' do
      before do
        model_klazz.create({ email_address: 'foo@bar.com' })
        model_klazz.create({ email_address: 'baz@bar.com' })
      end

      it 'finds the first matching model' do
        expect(model_klazz.with_email('foo@bar.com')).to be_a TestingRecord::Model
      end
    end

    context 'when entity exists with an `email-address` key' do
      before do
        model_klazz.create({ 'email-address': 'foo@bar.com' })
        model_klazz.create({ 'email-address': 'baz@bar.com' })
      end

      it 'finds the first matching model (which is stored as a snake_cased key)' do
        expect(model_klazz.with_email('foo@bar.com')).to be_a TestingRecord::Model
      end
    end

    context 'when entity exists with an `email` key' do
      before do
        model_klazz.primary_key :email
        model_klazz.create({ email: 'foo@bar.com' })
        model_klazz.create({ email: 'baz@bar.com' })
      end

      it 'finds the first matching model' do
        expect(model_klazz.with_email('foo@bar.com')).to be_a TestingRecord::Model
      end
    end
  end

  describe '.find_by - `:and` logic' do
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
        expect(model_klazz.find_by({ foo: 3, other: :foo, email_address: 'foo@foo.com' })).to eq([foo_entity])
      end

      it 'returns a blank collection when no entities match all query attributes' do
        expect(model_klazz.find_by({ foo: 3, other: :jeff, email_address: 'foo@foo.com' })).to eq([])
      end
    end
  end

  describe '.find_by - `:or` logic' do
    let(:foo_entity) { model_klazz.create({ email_address: 'foo@foo.com', foo: 3, other: :foo }) }
    let(:bar_entity) { model_klazz.create({ email_address: 'bar@bar.com', foo: 3, other: :bar }) }
    let(:baz_entity) { model_klazz.create({ email_address: 'baz@baz.com', foo: 3, other: :baz }) }

    before do
      foo_entity
      bar_entity
      baz_entity
    end

    context 'with a simple 1 attribute query' do
      it 'returns a collection of entities that match the query - behaving the same as `:and` logic' do
        expect(model_klazz.find_by({ foo: 3 }, logic: :or)).to eq([foo_entity, bar_entity, baz_entity])
      end

      it 'returns a blank collection when no entities match the query - behaving the same as `:and` logic' do
        expect(model_klazz.find_by({ foo: 4 }, logic: :or)).to eq([])
      end
    end

    context 'with a more complex set of attributes as a query' do
      it 'returns a collection of entities that match any of the query attributes' do
        expect(model_klazz.find_by({ other: :bar, email_address: 'foo@foo.com' }, logic: :or)).to eq([foo_entity, bar_entity])
      end

      it 'returns a blank collection when no entities match any of the query attributes' do
        expect(model_klazz.find_by({ foo: 55, other: :jeff, email_address: 'jeff@foo.com' }, logic: :or)).to eq([])
      end
    end
  end

  describe '.find_by - invalid logic' do
    let(:foo_entity) { model_klazz.create({ email_address: 'foo@foo.com', foo: 3, other: :foo }) }

    it 'raises an error that the logic is not valid' do
      expect { model_klazz.find_by({ foo: 3 }, logic: :foo) }
        .to raise_error(TestingRecord::Error::InvalidArgumentError)
        .with_message('Invalid filtering logic option, must be `:and` or `:or`')
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
