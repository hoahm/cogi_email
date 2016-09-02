require 'spec_helper'

describe CogiEmail do
  subject { CogiEmail.new }

  describe '#hi' do
    it 'return nil' do
      expect(CogiEmail.hi).to eq(nil)
    end
  end

  VALID_EMAIL_ADDRESSES = [
    "a+b@plus-in-local.com",
    "a_b@underscore-in-local.com",
    "user@example.com",
    " user@example.com ",
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.org",
    "01234567890@numbers-in-local.net",
    "a@single-character-in-local.org",
    "one-character-third-level@a.example.com",
    "single-character-in-sld@x.org",
    "local@dash-in-sld.com",
    "letters-in-sld@123.com",
    "one-letter-sld@x.org",
    "uncommon-tld@sld.museum",
    "uncommon-tld@sld.travel",
    "uncommon-tld@sld.mobi",
    "country-code-tld@sld.uk",
    "country-code-tld@sld.rw",
    "local@sld.newTLD",
    "local@sub.domains.com",
    "aaa@bbb.co.jp",
    "nigel.worthington@big.co.uk",
    "f@c.com",
    "areallylongnameaasdfasdfasdfasdf@asdfasdfasdfasdfasdf.ab.cd.ef.gh.co.ca",
    "joe+ruby-mail@example.com"
  ]

  INVALID_EMAIL_ADDRESSES = [
    "",
    "f@s",
    "f@s.c",
    "@bar.com",
    "test@example.com@example.com",
    "test@",
    "@missing-local.org",
    "a b@space-in-local.com",
    "! \#$%\`|@invalid-characters-in-local.org",
    "<>@[]\`|@even-more-invalid-characters-in-local.org",
    "missing-sld@.com",
    "invalid-characters-in-sld@! \"\#$%(),/;<>_[]\`|.org",
    "missing-dot-before-tld@com",
    "missing-tld@sld.",
    " ",
    "missing-at-sign.net",
    "unbracketed-IP@127.0.0.1",
    "invalid-ip@127.0.0.1.26",
    "another-invalid-ip@127.0.0.256",
    "IP-and-port@127.0.0.1:25",
    "the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net",
    "user@example.com\n<script>alert('hello')</script>"
  ]

  describe '#validate?' do
    context 'valid email address' do
      VALID_EMAIL_ADDRESSES.each do |email|
        it "#{email.inspect} should be valid" do
          expect(CogiEmail.validate?(email)).to be_truthy
        end
      end
    end

    context 'invalid email address' do
      INVALID_EMAIL_ADDRESSES.each do |email|
        it "#{email.inspect} should not be valid" do
          expect(CogiEmail.validate?(email)).to be_falsey
        end
      end
    end
  end

  describe '#normalize' do
    context 'valid email address' do
      VALID_EMAIL_ADDRESSES.each do |email|
        it "#{email.inspect} return an valid email address" do
          expect(CogiEmail.normalize(email)).to eq(email.strip.downcase)
        end
      end

      [
        "",
        "test@",
        "@missing-local.org",
        "a b@space-in-local.com",
        "! \#$%\`|@invalid-characters-in-local.org",
        "<>@[]\`|@even-more-invalid-characters-in-local.org",
        "invalid-characters-in-sld@! \"\#$%(),/;<>_[]\`|.org",
        "missing-tld@sld.",
        " ",
        "IP-and-port@127.0.0.1:25",
        "user@example.com\n<script>alert('hello')</script>"
      ].each do |email|
        it "#{email.inspect} raise error" do
          expect{ CogiEmail.normalize(email) }.to raise_error(CogiEmail::NormalizationError)
        end
      end
    end
  end
end
