require 'cogi_email/error'
require 'cogi_email/version'
require 'mail'

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
end
