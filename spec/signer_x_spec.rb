require 'spec_helper'

RSpec.describe Eet::SignerX do
  describe '#sign' do
    it 'signs message with WS security' do
      certificate = OpenSSL::PKCS12.new(File.open('spec/fixtures/EET_CA1_Playground-CZ00000019.p12'), 'eet')
      signer = Eet::SignerX.new

      msg = Nokogiri::XML(File.open('spec/fixtures/unsigned_message.xml'))
      signed_message = signer.sign(msg.to_xml, certificate)

      expect(signed_message).to eq File.read('spec/fixtures/signed_message.xml')
    end
  end
end
