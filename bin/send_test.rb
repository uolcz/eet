#!/usr/bin/env ruby

require 'bundler/setup'
require 'eet'

certificate = OpenSSL::PKCS12.new(File.open('spec/fixtures/EET_CA1_Playground-CZ00000019.p12'), 'eet')

data_to_register = { celk_trzba: '0.00', dat_trzby: "2017-02-04T13:09:55+00:00", dic_popl: "CZ00000019", id_pokl: "p1_czk", id_provoz: '11', porad_cis: '158', rezim: '0' }

pkp = Eet::Utils.create_pkp(data_to_register, certificate)
bkp = Eet::Utils.create_bkp(pkp)

data = { timestamp: Time.now.strftime('%FT%T%:z'), pkp: pkp, bkp: bkp, data: data_to_register }

message = Eet::Message.new(data)

signer = Eet::SignerX.new
signed_message = signer.sign(message.to_xml, certificate)

sender = Eet::Sender.new
response = sender.call(signed_message)

puts response.body
