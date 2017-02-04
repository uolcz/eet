module Eet
  module Utils
    def self.create_pkp(data, certificate)
      digest = OpenSSL::Digest::SHA256.new
      signature = certificate.key.sign(digest, serialize_pkp_data(data))
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

    def self.serialize_pkp_data(data)
      [data.fetch(:dic_popl),
       data.fetch(:id_provoz),
       data.fetch(:id_pokl),
       data.fetch(:porad_cis),
       data.fetch(:dat_trzby),
       data.fetch(:celk_trzba)].join('|')
    end
  end
end
