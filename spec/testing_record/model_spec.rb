# frozen_string_literal: true

RSpec.describe TestingRecord::Model do
  subject(:instance) { refined_class.create({ bar: 'value1', baz: 42 }) }

  let(:refined_class) do
    Class.new(described_class) do
      attribute :bar
      attribute :baz
      attribute :bay

      def self.name
        'Namespace::AnonymousModel'
      end
    end
  end

  describe '.create' do
    context 'with caching enabled' do
      before do
        stub_const('FakeModel', Class.new(described_class))
        FakeModel.caching :enabled
      end

      it 'generates a new instance of the entity' do
        expect(FakeModel.create).to be_a FakeModel
      end

      it 'adds the entity to the cache' do
        expect { FakeModel.create }.to change(FakeModel.all, :length).by(1)
      end

      it 'updates the `.current` status to the newly created entity' do
        instance = FakeModel.create

        expect(FakeModel.current).to eq(instance)
      end
    end

    context 'without caching enabled' do
      before do
        stub_const('FakeModel', Class.new(described_class))
        FakeModel.caching :disabled
      end

      it 'generates a new instance of the entity' do
        expect(FakeModel.create).to be_a FakeModel
      end
    end

    it 'does not store a default value of for attributes' do
      expect(instance.bay).to be_nil
    end
  end

  describe '.delete' do
    let(:primary_model_entity) { FakeModel.create({ id: 1 }) }
    let(:secondary_model_entity) { FakeOtherModel.create({ id: 1 }) }

    before do
      stub_const('FakeModel', Class.new(described_class))
      stub_const('FakeOtherModel', Class.new(described_class))
    end

    context 'with caching enabled' do
      before do
        FakeModel.caching :enabled
        FakeOtherModel.caching :enabled
        primary_model_entity
        secondary_model_entity
      end

      it 'deletes an entity that is present in the cache' do
        expect { FakeModel.delete(primary_model_entity) }.to change(FakeModel.all, :length).by(-1)
      end

      it 'does not delete entities that are not present in the cache' do
        expect { FakeModel.delete(secondary_model_entity) }.not_to change(FakeModel.all, :length)
      end
    end

    context 'without caching enabled' do
      before do
        FakeModel.caching :disabled
        primary_model_entity
      end

      it 'does nothing' do
        expect(FakeModel.delete(primary_model_entity)).to be_nil
      end
    end
  end

  describe '#inspect' do
    it 'returns a string representation of the model with its attributes' do
      expect(instance.inspect).to eq('#<Namespace::AnonymousModel @bar="value1", @baz=42>')
    end

    it 'shows the primary attribute first if defined' do
      refined_class.primary_key :baz
      expect(instance.inspect).to eq('#<Namespace::AnonymousModel @baz=42, @bar="value1">')
    end
  end

  describe '#to_s' do
    it 'returns the same string as #inspect' do
      expect(instance.to_s).to eq(instance.inspect)
    end
  end

  describe '#update' do
    subject(:instance) { described_class.create({ bar: 'initial', baz: 'initial' }) }

    it 'updates the attribute values on the instance' do
      instance.update({ bar: 'updated' })

      expect(instance.bar).to eq('updated')
    end

    it 'updates the attributes hash accordingly' do
      instance.update({ baz: 'bazzy' })

      expect(instance.attributes[:baz]).to eq('bazzy')
    end
  end
end
