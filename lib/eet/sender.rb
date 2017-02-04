require 'savon'

module Eet
  class Sender
    WSDL = 'https://pg.eet.cz:443/eet/services/EETServiceSOAP/v3?wsdl'
    TIMEOUT = 2
    ENDPOINT = :odeslani_trzby
    attr_reader :message

    def call(xml, wsdl = WSDL, timeout = TIMEOUT, endpoint = ENDPOINT)
      client = Savon.client(wsdl: wsdl, open_timeout: timeout)
      response = client.call(endpoint, xml: xml)
      response
    end
  end
end
