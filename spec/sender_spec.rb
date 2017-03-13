require "spec_helper"

RSpec.describe Eet::Sender do
  describe '#send_to_playground' do
    it 'sends given message to eet playground' do
      VCR.use_cassette('official_example_playground_submit') do
        sender = Eet::Sender.new
        message = File.read('./spec/fixtures/CZ00000019.valid.v3.1.xml')

        response = sender.send_to_playground(message)

        expect(response.body[:odpoved][:potvrzeni][:@fik]).to eq 'adea8e1d-2d96-4f41-b3c2-cd81e158bacd-ff'
      end
    end
  end
end
