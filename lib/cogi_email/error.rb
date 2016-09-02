module CogiEmail
  class NormalizationError < StandardError
    def initialize
      super %Q{Can not normalize the given email address. It is not an valid email address.}
    end
  end
end
