RSpec.describe SimpleErr::ExceptionHandler do
  let(:exception_msg) { 'test msg' }
  let(:exception) { Exception.new(exception_msg) }
  describe '::handle' do
    subject { described_class.handle(exception) }
    before do
      expect_any_instance_of(SimpleErr::ExceptionHandler).to receive(:handle).and_return(true)
    end
    it 'delegates the call to an instance' do
      expect(subject).to be true
    end
  end

  describe '#handle', :vcr do
    subject { described_class.new.handle(exception) }
    before do
      SimpleErr.configure do |c|
        c.client_app_id = 1
      end
      expect_any_instance_of(SimpleErr::CreateRequest).to receive(:perform).and_call_original
    end
    it { is_expected.to be true }

    context 'when exception is nil' do
      let(:exception) { nil }
      it { is_expected.to be false }
    end
  end

  describe 'protected#request_payload' do
    subject { described_class.new.send(:create_request_payload, exception) }
    it { is_expected.to include(message: exception_msg) }
    it { is_expected.to include(exception_name: 'Exception') }
    it { is_expected.to include(backtrace: nil) }
    context 'when exception is nil' do
      let(:exception) { nil }
      it { is_expected.to be nil }
    end
  end
end
