require 'spec_helper'
require 'nokogiri'

RSpec.describe Eet::Message do
  describe '::new' do
    it 'can be initialized with hash of attributes' do
      msg = Eet::Message.new(prvni_zaslani: true)

      expect(msg.prvni_zaslani).to eq true
    end

    it 'fails if initialized with unknown attribute' do
      expect { Eet::Message.new(nonsensee: true) }.to raise_error NoMethodError
    end
  end

  describe '#body' do
    it "is valid against it's xsd schema if it has all required attributes" do
      message = Eet::Message.new({ dic_popl: 'CZ00000019',
                                   id_provoz: '11',
                                   id_pokl: 'pokladna1',
                                   porad_cis: 1,
                                   celk_trzba: '100.00',
                                   pkp: 'foVMrKijhov6dJ0b3q+TfBpchBZCdnp5LAosovz7ufTZDnO2jb9S2KPqhn25R6CPfhLjMDL38ui7vn3xy25av4L34fn4qhnsbdzIw9wpco4En81s+TZ23HypRUUyGjsik0sTgn2FB8nLDR8VhNI96NSaGrXqhPcjDhUUgbmRvb6OAtOCYPWwEmn1iKsq276rfivHCGa4VgRHB9s6Lx3TL+bG6tRv2ErLkky855lpVcGOfg9aKuA4DCZC78Zqj+DjdPHEThPurdYME9GKNHASInrr5Gpr1uGJemdhcdKIVlxnDKeyC451K4G2nufB60CIXB79QoHxUOALn4JhqNJOIQ==',
                                   bkp: '8AE6E1D6-B2BF469F-B04C3516-B020E3E0-3FCEC26A' })

      expect(message.body).to match_xsd('./spec/fixtures/EETXMLSchema.xsd')
    end

    it "is not valid against it's xsd schema if it misses required attributes" do
      message = Eet::Message.new({})

      expect(message.body).not_to match_xsd('./spec/fixtures/EETXMLSchema.xsd')
    end
  end

  describe '#envelope' do
    it "is valid against it's xsd schema" do
      message = Eet::Message.new({})

      expect(message.envelope).to match_xsd('./spec/fixtures/soap_envelope.xsd')
    end
  end

  describe '#uuid_zpravy' do
    it 'returns default if no uuid was set' do
      allow(SecureRandom).to receive(:uuid) { '--automatic_uuid--' }
      msg = Eet::Message.new()

      expect(msg.uuid_zpravy).to eq '--automatic_uuid--'
    end

    it 'returns given value' do
      msg = Eet::Message.new(uuid_zpravy: '--uuid--')

      expect(msg.uuid_zpravy).to eq '--uuid--'
    end
  end

  describe '#dat_odesl' do
    it 'returns default formatted time if no time given' do
      stubbed_time = Time.parse('1.1.2017 10:00 UTC')
      allow(Time).to receive(:now) { stubbed_time }
      msg = Eet::Message.new()

      expect(msg.dat_odesl).to eq '2017-01-01T10:00:00+00:00'
    end

    it 'returns given value' do
      msg = Eet::Message.new(dat_odesl: '1.1.2017')

      expect(msg.dat_odesl).to eq '1.1.2017'
    end
  end

  describe '#prvni_zaslani' do
    it 'returns default value if no value set' do
      msg = Eet::Message.new()

      expect(msg.prvni_zaslani).to eq true
    end

    it 'returns given value' do
      msg = Eet::Message.new(prvni_zaslani: false)

      expect(msg.prvni_zaslani).to eq false
    end
  end

  describe '#rezim' do
    it 'returns default value if no value given' do
      msg = Eet::Message.new()

      expect(msg.rezim).to eq 0
    end

    it 'returns given value' do
      msg = Eet::Message.new(rezim: 1)

      expect(msg.rezim).to eq 1
    end
  end

  describe '#dat_trzby' do
    it 'returns given value but formatted' do
      
    end
    
  end

  describe '#head_attributes' do
    it 'returns hash with attributes for Hlavicka element' do
      msg = Eet::Message.new(uuid_zpravy: '--uuid--',
                             dat_odesl: Time.parse('1.1.2017 00:00 UTC').strftime(Eet::Message::DATE_FORMAT),
                             prvni_zaslani: true, overeni: false )

      expect(msg.head_attributes)
        .to match({ uuid_zpravy: '--uuid--', dat_odesl: "2017-01-01T00:00:00+00:00", prvni_zaslani: true, overeni: false })
    end

    it 'omits attributes which value is nil' do
      msg = Eet::Message.new(uuid_zpravy: '--uuid--',
                             dat_odesl: Time.parse('1.1.2017 00:00 UTC').strftime(Eet::Message::DATE_FORMAT),
                             prvni_zaslani: true)

      expect(msg.head_attributes)
        .to match({ uuid_zpravy: '--uuid--', dat_odesl: "2017-01-01T00:00:00+00:00", prvni_zaslani: true })
    end
  end

  describe '#data_attributes' do
    it 'returns hash with attributes for Data element' do
      msg = Eet::Message.new(dic_popl: 'CZ00000019',
                             dic_poverujiciho: 'CZ1212121218',
                             id_provoz: '1',
                             id_pokl: '11',
                             porad_cis: '1',
                             dat_trzby: Time.parse('1.1.2017 00:00 UTC').strftime(Eet::Message::DATE_FORMAT),
                             celk_trzba: '100',
                             zakl_nepodl_dph: '100',
                             zakl_dan1: '100',
                             dan1: '100',
                             zakl_dan2: '100',
                             dan2: '100',
                             zakl_dan3: '100',
                             dan3: '100',
                             cest_sluz: '100',
                             pouzit_zboz1: '100',
                             pouzit_zboz2: '100',
                             pouzit_zboz3: '100',
                             urceno_cerp_zuct: '100',
                             cerp_zuct: '100',
                             rezim: 0)

      expect(msg.data_attributes)
        .to match({ dic_popl: 'CZ00000019',
                    dic_poverujiciho: 'CZ1212121218',
                    id_provoz: '1',
                    id_pokl: '11',
                    porad_cis: '1',
                    dat_trzby: '2017-01-01T00:00:00+00:00',
                    celk_trzba: '100',
                    zakl_nepodl_dph: '100',
                    zakl_dan1: '100',
                    dan1: '100',
                    zakl_dan2: '100',
                    dan2: '100',
                    zakl_dan3: '100',
                    dan3: '100',
                    cest_sluz: '100',
                    pouzit_zboz1: '100',
                    pouzit_zboz2: '100',
                    pouzit_zboz3: '100',
                    urceno_cerp_zuct: '100',
                    cerp_zuct: '100',
                    rezim: 0 })
    end

    it 'omits attributes which value is nil' do
      stubbed_time = Time.parse('1.1.2017 10:00 UTC')
      allow(Time).to receive(:now) { stubbed_time }
      msg = Eet::Message.new(rezim: 1)

      expect(msg.data_attributes)
        .to match({ rezim: 1, dat_trzby: '2017-01-01T10:00:00+00:00' })
    end
  end
end
