require "spec_helper"

RSpec.describe Eet::Sender do
  describe '#call' do
    it "sends given message to eet endpoint" do
      VCR.use_cassette('official_example_msg_submit') do
        sender = Eet::Sender.new
        message = File.read('./spec/fixtures/CZ00000019.valid.v3.1.xml')

        response = sender.call(message)

        expect(response.body[:odpoved][:potvrzeni][:@fik]).to eq '26742939-eb3e-49e5-a583-8fbde063aa2c-ff'
      end
    end
  end
end
