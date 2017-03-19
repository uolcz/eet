require 'signer'

module Eet
  module Utils
    def self.create_pkp(message, certificate)
      digest = OpenSSL::Digest::SHA256.new
      signature = certificate.key.sign(digest, serialize_pkp_data(message))
      Base64.encode64(signature).delete("\n")
    end

    def self.create_bkp(pkp_value)
      decoded = Base64.decode64(pkp_value)
      digest = Digest::SHA1.digest(decoded)

      ret = ''
      encoded =
        digest.each_char do |c|
          ch = c.ord.to_s(16)
          ch = '0' + ch if ch.size == 1
          ret += ch
        end

      ret.upcase.chars.each_slice(8).map(&:join).join('-')
    end

    def self.sign(xml, certificate)
      signer = Signer.new(xml)
      signer.cert = certificate.certificate
      signer.private_key = certificate.key

      signer.security_node = signer.document.children.first.children.first.children.first
      signer.digest_algorithm = :sha256
      signer.signature_digest_algorithm = :sha256
      signer.ds_namespace_prefix = 'ds'
      signer.security_token_id = 'A79845F15C5549CA0514761283545705'
      signer.digest!(signer.document.at_xpath('//soap:Body'), inclusive_namespaces: [''])
      signer.sign!(security_token: true, inclusive_namespaces: ['soap'])

      signer.to_xml
    end

    def self.serialize_pkp_data(message)
      [message.dic_popl,
       message.id_provoz,
       message.id_pokl,
       message.porad_cis,
       message.dat_trzby,
       message.celk_trzba].join('|')
    end
  end
end
