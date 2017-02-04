require 'signer'

module Eet
  class SignerX
    def sign(xml, certificate)
      signer = Signer.new(xml)
      signer.cert = OpenSSL::X509::Certificate.new(certificate.certificate)
      signer.private_key = OpenSSL::PKey::RSA.new(certificate.key, 'eet')

      signer.security_node = signer.document.children.first.children.first.children.first
      signer.digest_algorithm = :sha256
      signer.signature_digest_algorithm = :sha256
      signer.ds_namespace_prefix = 'ds'
      signer.security_token_id = 'A79845F15C5549CA0514761283545705'
      signer.digest!(signer.document.at_xpath('//soap:Body'), inclusive_namespaces: [''])
      signer.sign!(security_token: true, inclusive_namespaces: ['soap'])

      signer.to_xml
    end
  end
end
