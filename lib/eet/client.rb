module Eet
  class Client
    attr_reader :certificate, :data

    def initialize(certificate, data)
      @certificate = certificate
      @data = data
    end

    def submit(environment)
      message = Eet::Message.new(data)
      message.pkp = Eet::Utils.create_pkp(message, certificate)
      message.bkp = Eet::Utils.create_bkp(message.pkp)

      signed_message = Eet::Utils.sign(message.to_xml, certificate)

      sender = Eet::Sender.new

      if environment == :playground
        sender.send_to_playground(signed_message)
      elsif environment == :production
        sender.send_to_production(signed_message)
      else
        raise Eet::UnknownEnvironmentError, "Unknown EET environment: #{environment}"
      end
    end
  end
end
