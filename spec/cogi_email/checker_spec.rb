require 'spec_helper'
require 'cogi_email/checker'

describe CogiEmail::Checker do
  describe '#verify' do
    it 'return true if valid email address' do
      v = CogiEmail::Checker.new('nobi.younet@gmail.com')
      v.connect
      expect(v.verify).to be_truthy
    end

    it 'raise error if no mail server found' do
      v = CogiEmail::Checker.new('nobi.younet@example.com')
      expect{ v.connect }.to raise_error(CogiEmail::NoMailServerException)
    end

    it 'raise error if not connected' do
      v = CogiEmail::Checker.new('nobi.younet@gmail.com')
      expect{ v.verify }.to raise_error(CogiEmail::NotConnectedException)
    end
  end
end
