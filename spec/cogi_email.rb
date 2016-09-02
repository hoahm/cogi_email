require 'spec_helper'

describe CogiEmail do
  subject { CogiEmail.new }

  describe '#hi' do
    it 'return nil' do
      expect(CogiEmail.hi).to eq(nil)
    end
  end
end
