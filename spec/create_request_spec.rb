# frozen_string_literal: true

RSpec.describe SimpleErr::CreateRequest do
  describe 'construction and validation' do
    let(:client_app_id) { 1 }
    let(:exception_name) { 'RuntimeError' }
    let(:message) { 'undefined method for foo' }
    let(:backtrace) { 'a\nb' }
    let(:payload) do
      {
        client_app_id: client_app_id,
        exception_name: exception_name,
        message: message,
        backtrace: backtrace
      }
    end
    let(:request) { described_class.new(payload) }
    subject { request }
    describe '#new' do
      describe 'the set attributes' do
        describe 'exception_name' do
          subject { super().exception_name }
          it { is_expected.to eq(exception_name) }
        end
        describe 'message' do
          subject { super().message }
          it { is_expected.to eq(message) }
        end
      end
    end

    describe '#valid?' do
      subject { super().valid? }
      context 'all valid params' do
        it { is_expected.to be true }
      end
      context 'invalid params' do
        context 'missing exception name' do
          let(:exception_name) { nil }
          it { is_expected.to be false }
        end
        context 'missing message' do
          let(:message) { nil }
          it { is_expected.to be false }
        end
      end
    end

    describe '#perform', :vcr do
      subject { super().perform }
      describe 'the response code' do
        it { is_expected.to be true }
        context 'with nil params' do
          before do
            allow(request).to receive(:to_param).and_return(client_app_error: {
                                                              message: nil,
                                                              backtrace: nil,
                                                              exception_name: nil
                                                            })
          end
          it { is_expected.to be false }
        end
        context 'with missing params' do
          before do
            allow(request).to receive(:to_param).and_return(client_app_error: {})
          end
          it { is_expected.to be false }
        end

        context 'when self is invalid' do
          before do
            allow(request).to receive(:valid?).and_return(false)
            it { is_expected.to be false }
          end
        end
      end
    end

    describe '#to_param' do
      subject { super().to_param }
      it { is_expected.to include(:client_app_error) }
      describe 'the number of keys' do
        it { expect(subject.keys.size).to eq(1) }
      end

      describe 'the root body' do
        subject { super()[:client_app_error] }
        it { is_expected.to include(message: message) }
        it { is_expected.to include(backtrace: backtrace) }
        it { is_expected.to include(exception_name: exception_name) }
      end
    end
  end
end
