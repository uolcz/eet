require 'nokogiri'
require 'base64'
require 'digest'
require 'securerandom'

module Eet
  class Message
    SOAP_ENV_SCHEMA = 'http://schemas.xmlsoap.org/soap/envelope/'
    WSSE_SCHEMA = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'
    WSU_SCHEMA = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'
    WSU_ID = 'artificial_id'
    BEZNY_REZIM = 0
    DATE_FORMAT = '%FT%T%:z'

    attr_writer :uuid_zpravy, :dat_odesl, :prvni_zaslani, :rezim

    attr_accessor :pkp, :bkp, :overeni, :dic_poverujiciho, :zakl_nepodl_dph, :zakl_dan1, :dan1, :dic_popl,
                  :zakl_dan2, :dan2, :zakl_dan3, :dan3, :cest_sluz, :pouzit_zboz1, :pouzit_zboz2, :pouzit_zboz3,
                  :urceno_cerp_zuct, :cerp_zuct, :id_provoz, :id_pokl, :porad_cis, :dat_trzby, :celk_trzba

    def initialize(attributes = {})
      attributes.each do |k, v|
        public_send("#{k}=", v)
      end
    end

    def body
      Nokogiri::XML::Builder.new('encoding' => 'UTF-8') do |xml|
        xml.Trzba(xmlns: 'http://fs.mfcr.cz/eet/schema/v3') do
          xml.Hlavicka(head_attributes)

          xml.Data(data_attributes)

          xml.KontrolniKody do
            xml.pkp(cipher: 'RSA2048', digest: 'SHA256', encoding: 'base64') do
              xml.text(pkp)
            end

            xml.bkp(digest: 'SHA1', encoding: 'base16') do
              xml.text(bkp)
            end
          end
        end
      end.doc
    end

    def envelope
      Nokogiri::XML::Builder.new('encoding' => 'UTF-8') do |xml|
        xml['soap'].Envelope('xmlns:soap' => "http://schemas.xmlsoap.org/soap/envelope/") do
          xml['SOAP-ENV'].Header('xmlns:SOAP-ENV' => SOAP_ENV_SCHEMA) do
            xml['wsse'].Security('xmlns:wsse' => WSSE_SCHEMA, 'xmlns:wsu' => WSU_SCHEMA, 'soap:mustUnderstand' => '1')
          end

          xml['soap'].Body('xmlns:wsu' => WSU_SCHEMA, 'wsu:Id' => WSU_ID) do
          end
        end
      end.doc
    end

    def to_xml
      msg = envelope.dup
      body = msg.at_xpath('//soap:Body')
      body.add_child(self.body.root)

      msg
    end

    def uuid_zpravy
      @uuid_zpravy ||= SecureRandom.uuid
    end

    def dat_odesl
      @dat_odesl ||= Time.now.strftime(DATE_FORMAT)
    end

    def prvni_zaslani
      @prvni_zaslani.nil? ? true : @prvni_zaslani
    end

    def rezim
      @rezim ||= BEZNY_REZIM
    end

    def dat_trzby
      @dat_trzby ||= Time.now.strftime(DATE_FORMAT)
    end

    def head_attributes
      { uuid_zpravy: uuid_zpravy,
        dat_odesl: dat_odesl,
        prvni_zaslani: prvni_zaslani,
        overeni: overeni
      }.reject { |_, v| v.nil? }
    end

    def data_attributes
      { dic_popl: dic_popl,
        dic_poverujiciho: dic_poverujiciho,
        id_provoz: id_provoz,
        id_pokl: id_pokl,
        porad_cis: porad_cis,
        dat_trzby: dat_trzby,
        celk_trzba: celk_trzba,
        zakl_nepodl_dph: zakl_nepodl_dph,
        zakl_dan1: zakl_dan1,
        dan1: dan1,
        zakl_dan2: zakl_dan2,
        dan2: dan2,
        zakl_dan3: zakl_dan3,
        dan3: dan3,
        cest_sluz: cest_sluz,
        pouzit_zboz1: pouzit_zboz1,
        pouzit_zboz2: pouzit_zboz2,
        pouzit_zboz3: pouzit_zboz3,
        urceno_cerp_zuct: urceno_cerp_zuct,
        cerp_zuct: cerp_zuct,
        rezim: rezim,
      }.reject { |_, v| v.nil? }
    end
  end
end
