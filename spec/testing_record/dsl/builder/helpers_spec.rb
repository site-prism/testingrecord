# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Helpers do
  subject(:instance) { klazz.new }

  describe '.add_helpers' do
    context 'with a default property' do
      let(:klazz) do
        Class.new(TestingRecord::Model) do
          property :foo
          add_helpers
        end
      end

      it 'will add the #any? helper to the singular property of the model' do
        expect(instance).to respond_to(:foo?)
      end
    end

    context 'with a singular property' do
      let(:klazz) do
        Class.new(TestingRecord::Model) do
          property :bar, type: :singular
          add_helpers
        end
      end

      it 'will add the #any? helper to the singular property of the model' do
        expect(instance).to respond_to(:bar?)
      end
    end

    context 'with a plural property' do
      let(:klazz) do
        Class.new(TestingRecord::Model) do
          property :baz, type: :plural
          add_helpers
        end
      end

      it 'will add the #any? helper to the plural property of the model' do
        expect(instance).to respond_to(:bazs?)
      end
    end
  end
end
