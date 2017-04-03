require 'spec_helper'

RSpec.describe Eet::Client do
  describe '#submit' do
    let(:data) { { celk_trzba: '100.00', dic_popl: 'CZ00000019', id_pokl: 'p1', id_provoz: '11', porad_cis: '1'} }
    let(:certificate) { Eet.playground_certificate }

    it 'submits EET to given environment' do
      client = Eet::Client.new(certificate, data)
      expect_any_instance_of(Eet::Sender).to receive(:send_to_playground)
      client.submit(:playground)
    end

    it 'raises UnknownEnvironment error' do
      client = Eet::Client.new(certificate, data)
      expect {
        client.submit(:nonexisting)
      }.to raise_error(Eet::UnknownEnvironmentError)
    end
  end
end
