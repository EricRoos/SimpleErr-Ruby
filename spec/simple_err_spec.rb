# frozen_string_literal: true

RSpec.describe SimpleErr do
  it 'has a version number' do
    expect(SimpleErr::VERSION).not_to be nil
  end

  describe '::configuration' do
    subject { described_class.configuration }
    it { is_expected.to_not be nil }
  end

  describe '::configure' do
    before do
      SimpleErr.configure do |c|
        c.client_app_id = 1
      end
    end
    subject { SimpleErr.configuration }
    describe 'the client_app_id' do
      subject { super().client_app_id }
      it { is_expected.to eq(1) }
    end
  end
end
