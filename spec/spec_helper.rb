$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'eet'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec::Matchers.define :match_xsd do |expected|
  match do |actual|
    schema = Nokogiri::XML::Schema(File.open(expected))
    errors = schema.validate(actual)

    errors.size == 0
  end

  failure_message do |actual|
    schema = Nokogiri::XML::Schema(File.open(expected))
    errors = schema.validate(actual)

    msg = "expected given document to match #{expected} schema but there are following errors:"
    errors.insert(0, msg).join("\n")
  end
end
