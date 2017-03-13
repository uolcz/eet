#!/usr/bin/env ruby

require 'bundler/setup'
require 'eet'

certificate = OpenSSL::PKCS12.new(File.open('spec/fixtures/EET_CA1_Playground-CZ00000019.p12'), 'eet')

data = { celk_trzba: '0.00', dic_popl: 'CZ00000019', id_pokl: 'p1', id_provoz: '11', porad_cis: '1', rezim: '0' }
message = Eet::Message.new(data)

message.pkp = Eet::Utils.create_pkp(message, certificate)
message.bkp = Eet::Utils.create_bkp(message.pkp)

signed_message = Eet::Utils.sign(message.to_xml, certificate)

sender = Eet::Sender.new
response = sender.call(signed_message)

puts response.body
