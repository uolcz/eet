require 'spec_helper'

RSpec.describe Eet::Utils do
  let(:data) do
    { dic_popl: 'CZ72080043',
      id_provoz: '181',
      id_pokl: '00/2535/CN58',
      porad_cis: '0/2482/IE25',
      dat_trzby: '2016-12-07T22:01:00+01:00',
      celk_trzba: '87988.00' }
  end

  describe '::create_pkp' do
    it 'creates pkp' do
      certificate = OpenSSL::PKCS12.new(File.open('spec/fixtures/EET_CA1_Playground-CZ00000019.p12'), 'eet')

      expected_pkp = 'foVMrKijhov6dJ0b3q+TfBpchBZCdnp5LAosovz7ufTZDnO2jb9S2KPqhn25R6CPfhLjMDL38ui7vn3xy25av4L34fn4qhnsbdzIw9wpco4En81s+TZ23HypRUUyGjsik0sTgn2FB8nLDR8VhNI96NSaGrXqhPcjDhUUgbmRvb6OAtOCYPWwEmn1iKsq276rfivHCGa4VgRHB9s6Lx3TL+bG6tRv2ErLkky855lpVcGOfg9aKuA4DCZC78Zqj+DjdPHEThPurdYME9GKNHASInrr5Gpr1uGJemdhcdKIVlxnDKeyC451K4G2nufB60CIXB79QoHxUOALn4JhqNJOIQ=='

      expect(Eet::Utils.create_pkp(data, certificate)) .to eq expected_pkp
    end
  end

  describe '::create_bkp' do
    it 'creates bkp from pkp' do
      pkp = 'foVMrKijhov6dJ0b3q+TfBpchBZCdnp5LAosovz7ufTZDnO2jb9S2KPqhn25R6CPfhLjMDL38ui7vn3xy25av4L34fn4qhnsbdzIw9wpco4En81s+TZ23HypRUUyGjsik0sTgn2FB8nLDR8VhNI96NSaGrXqhPcjDhUUgbmRvb6OAtOCYPWwEmn1iKsq276rfivHCGa4VgRHB9s6Lx3TL+bG6tRv2ErLkky855lpVcGOfg9aKuA4DCZC78Zqj+DjdPHEThPurdYME9GKNHASInrr5Gpr1uGJemdhcdKIVlxnDKeyC451K4G2nufB60CIXB79QoHxUOALn4JhqNJOIQ=='

      expect(Eet::Utils.create_bkp(pkp)).to eq '8AE6E1D6-B2BF469F-B04C3516-B020E3E0-3FCEC26A'
    end
  end

  describe 'serialize_pkp_data' do
    it "serializes pkp data into string divided by '|'" do
      expect(Eet::Utils.serialize_pkp_data(data))
        .to eq "CZ72080043|181|00/2535/CN58|0/2482/IE25|2016-12-07T22:01:00+01:00|87988.00"
    end

    it 'fails if any needed data is missing' do
      data = {}

      expect {Eet::Utils.serialize_pkp_data(data)}.to raise_error(KeyError)
    end
  end
end
