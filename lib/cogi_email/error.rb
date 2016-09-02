module CogiEmail
  class NormalizationError < StandardError
    def initialize
      super %Q{Can not normalize the given email address. It is not an valid email address.}
    end
  end

  class NoMailServerException < StandardError; end
  class OutOfMailServersException < StandardError; end
  class NotConnectedException < StandardError; end
  class FailureException < StandardError; end
end
