module Eet
  class Client
  #Usage:
    #client = Client.new(eet_certificate, prepared_eet_data)

    #if you need pkp and bkp values before you actually register then you do need to run this first:

    #client.prepare_message

    #pkp and bkp values are exposed through message instance on the client:

    #client.message.pkp
    #client.message.bkp

    #now you can continue with register action:

    #client.register(:production)
    class MessageNotPrepared < StandardError; end

    attr_reader :certificate, :data, :message, :signed_message

    def initialize(certificate, data)
      @certificate = certificate
      @data = data
      @message = nil
      @signed_message = nil
    end

    def submit(environment)
      prepare_message
      register(environment)
    end

    def prepare_message
      @message = Eet::Message.new(data)
      @message.pkp = Eet::Utils.create_pkp(message, certificate)
      @message.bkp = Eet::Utils.create_bkp(message.pkp)

      @signed_message = Eet::Utils.sign(message.to_xml, certificate)
    end

    def register(environment)
      raise MessageNotPrepared unless signed_message

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
