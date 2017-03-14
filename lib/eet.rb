require 'eet/version'
require 'eet/message'
require 'eet/sender'
require 'eet/utils'

module Eet
  def self.test_playground
    data = { celk_trzba: '0.00',
             dic_popl: 'CZ00000019',
             id_pokl: 'p1',
             id_provoz: '11',
             porad_cis: '1',
             rezim: '0' }
    message = Message.new(data)

    message.pkp = Utils.create_pkp(message, playground_certificate)
    message.bkp = Utils.create_bkp(message.pkp)

    signed_message = Utils.sign(message.to_xml, playground_certificate)

    sender = Sender.new
    response = sender.send_to_playground(signed_message)
  end

  def self.playground_certificate
    OpenSSL::PKCS12.new(File.open('spec/fixtures/EET_CA1_Playground-CZ00000019.p12'), 'eet')
  end
end
