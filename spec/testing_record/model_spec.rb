# frozen_string_literal: true

RSpec.describe TestingRecord::Model do
  describe '.type' do
    context 'when classified as a singular model' do
      let(:model) do
        Class.new(TestingRecord::Model) do
          type :singular
        end
      end

      it 'sets the singular model properties' do
        expect(model.instance_variable_get(:@type)).to eq(:singular)
      end
    end

    context 'when classified as a plural model' do
      let(:model) do
        Class.new(TestingRecord::Model) do
          type :plural
        end
      end

      it 'sets the singular model properties' do
        expect(model.instance_variable_get(:@type)).to eq(:plural)
      end
    end
  end

  describe '.create_accessible_collection!' do
    before do
      stub_const('Foo', Class.new(described_class))
      Foo.create_accessible_collection!
    end

    it 'generates a new reader class method for accessing the raw data' do
      expect(Foo).to respond_to(:foos)
    end

    it 'auto-creates the cache as an empty array' do
      expect(Foo.foos).to eq([])
    end
  end

  describe '.create' do
    context 'with caching enabled' do
      before do
        stub_const('Foo', Class.new(described_class))
        Foo.create_accessible_collection!
      end

      it 'generates a new instance of your model entity' do
        expect(Foo.create({})).to be_a Foo
      end

      it 'will add the entity to the cache' do
        expect { Foo.create({}) }.to change(Foo.foos, :length).by(1)
      end
    end

    context 'without caching enabled' do
      before do
        stub_const('Foo', Class.new(described_class))
      end

      it 'generates a new instance of your model entity' do
        expect(Foo.create({})).to be_a Foo
      end
    end
  end
end
