# frozen_string_literal: true

RSpec.describe TestingRecord::Model do
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
