# frozen_string_literal: true

RSpec.describe TestingRecord::DSL::Builder::Filters do
  subject(:model_klazz) do
    Class.new(TestingRecord::Model) do
      caching :enabled
    end
  end

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
end
