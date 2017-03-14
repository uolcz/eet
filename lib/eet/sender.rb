require 'savon'

module Eet
  class Sender
    PLAYGROUND_WSDL = 'https://pg.eet.cz:443/eet/services/EETServiceSOAP/v3?wsdl'
    PRODUCTION_WSDL = 'https://prod.eet.cz:443/eet/services/EETServiceSOAP/v3?wsdl'
    TIMEOUT = 2
    ENDPOINT = :odeslani_trzby
    attr_reader :message

    def send_to_playground(xml, wsdl = PLAYGROUND_WSDL, timeout = TIMEOUT, endpoint = ENDPOINT)
      client = Savon.client(wsdl: wsdl, open_timeout: timeout)
      response = client.call(endpoint, xml: xml)
      response
    end

    def send_to_production(xml, wsdl = PRODUCTION_WSDL, timeout = TIMEOUT, endpoint = ENDPOINT)
      client = Savon.client(wsdl: wsdl, open_timeout: timeout)
      response = client.call(endpoint, xml: xml)
      response
    end
  end
end
