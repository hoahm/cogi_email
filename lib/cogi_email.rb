require 'cogi_email/checker'
require 'cogi_email/error'
require 'cogi_email/version'
require 'mail'
require 'resolv'

module CogiEmail
  def self.hi
    puts "Hello from Cogi::Email"
  end

  # Check if a string is a valid email address.
  #
  # This library is so strict to ensure that all email is clean and deliverable.
  #
  # References:
  #   https://www.jochentopf.com/email/
  #   https://fightingforalostcause.net/content/misc/2006/compare-email-regex.php
  #
  # @param [String] email Email address
  #
  # @return [Boolean] True if it is in a valid email, otherwise False
  #
  # @example
  #
  #   CogiEmail.validate?('peter_brown@example.com') # => true
  #   CogiEmail.validate?('peter-brown@example.com') # => true
  #   CogiEmail.validate?('peter.brown@example.com') # => true
  #   CogiEmail.validate?('peter brown@example.com') # => false
  #   CogiEmail.validate?('peter_brown@@example.com') # => false
  def self.validate?(email)
    pattern = /\A\s*([-\p{L}\d+._]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\s*\z/i
    !!(email =~ pattern)
  end

  # Normalize email address.
  #
  # You need to validate before normalize an email address.
  #
  # @param [String] email Email address
  #
  # @return [String] Email address in lowercase, without special characters.
  #
  # @raise [CogiEmail::NormalizationError] If can not normalize the email address.
  #
  # @example
  #   CogiEmail.normalize('(Peter Brown)<peter_brown@example.com>') # => peter_brown@example.com
  #   CogiEmail.normalize('peter_brown@example.com') # => peter_brown@example.com
  #   CogiEmail.normalize('Peter_Brown@example.com') # => peter_brown@example.com
  #   CogiEmail.normalize('peter brown@example.com') # => peter_brown@example.com
  def self.normalize(email)
    begin
      m = Mail::Address.new(email)
      m.address.downcase
    rescue
      raise CogiEmail::NormalizationError
    end
  end

  # Check if email domain is valid by making a DNS lookup.
  #
  # An email domain is valid if it has an MX DNS record is set up to receive mail.
  #
  # Reference: https://www.safaribooksonline.com/library/view/ruby-cookbook/0596523696/ch01s19.html
  #
  # @param [String] email Email address
  #
  # @return [Boolean] True if email domain have valid MX DNS record, otherwise False
  def self.valid_email_domain?(email)
    valid = true

    begin
      m = Mail::Address.new(email)
      hostname = m.domain
      Resolv::DNS.new.getresource(hostname, Resolv::DNS::Resource::IN::MX)
    rescue Resolv::ResolvError
      valid = false
    end

    valid
  end

  # Check if an email address is real or not.
  #
  # An email address is real if:
  #   Valid
  #   Has MX DNS record
  #   Can send test email
  #
  # @param [String] email Email address
  #
  # @return [Boolean] True if email address is real, otherwise False
  #
  # @example
  #   CogiEmail.real_email?('nobi.younet@gmail.com')   # => true
  #   CogiEmail.real_email?('nobi.younet@example.com') # => false
  def self.real_email?(email)
    return false unless self.validate?(email) # not a valid email address
    result = true

    begin
      v = CogiEmail::Checker.new(email)
      v.connect
      v.verify
    rescue
      result = false
    end

    result
  end
end
