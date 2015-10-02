require 'spec_helper'

describe DirtinessValidator do
  it 'has a version number' do
    expect(DirtinessValidator::VERSION).not_to be nil
  end

  describe '#validate_each' do
    let(:previous_value) { 100 }
    let(:model) { TestModel.new(attr: previous_value).tap(&:save) }
    subject { model.valid? }

    before { model.attr = current_value }
    after { TestModel.clear_validators! }

    describe 'greater' do
      before { TestModel.validates :attr, dirtiness: { greater: true } }

      context 'when current value is greater than the previous value' do
        let(:current_value) { 200 }
        it { expect { subject }.not_to change { model.errors[:attr] }.from([]) }
      end

      context 'when current value is equal to the previous value' do
        let(:current_value) { previous_value }
        it { expect { subject }.to change { model.errors[:attr] }.from([]).to([I18n.t('errors.messages.greater')]) }
      end

      context 'when current value is less than the previous value' do
        let(:current_value) { 50 }
        it { expect { subject }.to change { model.errors[:attr] }.from([]).to([I18n.t('errors.messages.greater')]) }
      end
    end

    describe 'greater_or_equal' do
      before { TestModel.validates :attr, dirtiness: { greater_or_equal: true } }

      context 'when current value is greater than the previous value' do
        let(:current_value) { 200 }
        it { expect { subject }.not_to change { model.errors[:attr] }.from([]) }
      end

      context 'when current value is equal to the previous value' do
        let(:current_value) { previous_value }
        it { expect { subject }.not_to change { model.errors[:attr] }.from([]) }
      end

      context 'when current value is less than the previous value' do
        let(:current_value) { 50 }
        it { expect { subject }.to change { model.errors[:attr] }.from([]).to([I18n.t('errors.messages.greater_or_equal')]) }
      end
    end

    describe 'less' do
      before { TestModel.validates :attr, dirtiness: { less: true } }

      context 'when current value is greater than the previous value' do
        let(:current_value) { 200 }
        it { expect { subject }.to change { model.errors[:attr] }.from([]).to([I18n.t('errors.messages.less')]) }
      end

      context 'when current value is equal to the previous value' do
        let(:current_value) { previous_value }
        it { expect { subject }.to change { model.errors[:attr] }.from([]).to([I18n.t('errors.messages.less')]) }
      end

      context 'when current value is less than the previous value' do
        let(:current_value) { 50 }
        it { expect { subject }.not_to change { model.errors[:attr] }.from([]) }
      end
    end

    describe 'less_or_equal' do
      before { TestModel.validates :attr, dirtiness: { less_or_equal: true } }

      context 'when current value is greater than the previous value' do
        let(:current_value) { 200 }
        it { expect { subject }.to change { model.errors[:attr] }.from([]).to([I18n.t('errors.messages.less_or_equal')]) }
      end

      context 'when current value is equal to the previous value' do
        let(:current_value) { previous_value }
        it { expect { subject }.not_to change { model.errors[:attr] }.from([]) }
      end

      context 'when current value is less than the previous value' do
        let(:current_value) { 50 }
        it { expect { subject }.not_to change { model.errors[:attr] }.from([]) }
      end
    end

    describe 'equal' do
      before { TestModel.validates :attr, dirtiness: { equal: true } }

      context 'when current value is greater than the previous value' do
        let(:current_value) { 200 }
        it { expect { subject }.to change { model.errors[:attr] }.from([]).to([I18n.t('errors.messages.equal')]) }
      end

      context 'when current value is equal to the previous value' do
        let(:current_value) { previous_value }
        it { expect { subject }.not_to change { model.errors[:attr] }.from([]) }
      end

      context 'when current value is less than the previous value' do
        let(:current_value) { 50 }
        it { expect { subject }.to change { model.errors[:attr] }.from([]).to([I18n.t('errors.messages.equal')]) }
      end
    end

    describe 'not_equal' do
      before { TestModel.validates :attr, dirtiness: { not_equal: true } }

      context 'when current value is greater than the previous value' do
        let(:current_value) { 200 }
        it { expect { subject }.not_to change { model.errors[:attr] }.from([]) }
      end

      context 'when current value is equal to the previous value' do
        let(:current_value) { previous_value }
        it { expect { subject }.to change { model.errors[:attr] }.from([]).to([I18n.t('errors.messages.not_equal')]) }
      end

      context 'when current value is less than the previous value' do
        let(:current_value) { 50 }
        it { expect { subject }.not_to change { model.errors[:attr] }.from([]) }
      end
    end

    describe 'when message option is given' do
      let(:custom_message) { 'custom message' }
      let(:current_value) { previous_value }
      before { TestModel.validates :attr, dirtiness: { greater: true,  message: custom_message } }

      it 'uses custom message' do
        expect { subject }.to change { model.errors[:attr] }.from([]).to([custom_message])
      end
    end
  end
end
