require 'net/smtp'
require 'resolv'

module CogiEmail
  class Checker
    ##
    # Returns server object for given email address or throws exception
    # Object returned isn't yet connected. It has internally a list of
    # real mail servers got from MX dns lookup
    #
    # Reference:
    #   https://github.com/kamilc/email_verifier/blob/master/lib/email_verifier/checker.rb
    def initialize(email)
      @email = email
      @smtp    = nil
      @user_email = 'nobody@nonexistant.com'
      _, @user_domain = @user_email.split "@"
    end

    def domain
      m = Mail::Address.new(@email)
      @domain = m.domain
    end

    def list_mxs
      return [] unless domain
      mxs = []
      Resolv::DNS.open do |dns|
        ress = dns.getresources domain, Resolv::DNS::Resource::IN::MX
        ress.each do |r|
          mxs << { priority: r.preference, address: r.exchange.to_s }
        end
      end

      @servers = mxs.sort_by { |mx| mx[:priority] }
      @servers
    end

    def is_connected
      !@smtp.nil?
    end

    def connect
      list_mxs
      raise CogiEmail::NoMailServerException.new("No mail server for #{@email}") if @servers.empty?

      begin
        server = next_server
        raise CogiEmail::OutOfMailServersException.new("Unable to connect to any one of mail servers for #{@email}") if server.nil?
        @smtp = Net::SMTP.start server[:address], 25, @user_domain
        return true
      rescue CogiEmail::OutOfMailServersException => e
        raise CogiEmail::OutOfMailServersException, e.message
      rescue => e
        retry
      end
    end

    def close_connection
      @smtp.finish if @smtp && @smtp.started?
    end

    def verify
      mailfrom @user_email
      rcptto(@email).tap do
        close_connection
      end
    end

    def next_server
      @servers.shift
    end

    private

    def ensure_connected
      raise CogiEmail::NotConnectedException.new("You have to connect first") if @smtp.nil?
    end

    def mailfrom(address)
      ensure_connected

      ensure_250 @smtp.mailfrom(address)
    end

    def rcptto(address)
      ensure_connected

      begin
        ensure_250 @smtp.rcptto(address)
      rescue => e
        if e.message[/^550/]
          return false
        else
          raise CogiEmail::FailureException.new(e.message)
        end
      end
    end

    def ensure_250(smtp_return)
      if smtp_return.status.to_i == 250
        return true
      else
        raise CogiEmail::FailureException.new "Mail server responded with #{smtp_return.status} when we were expecting 250"
      end
    end
  end
end
