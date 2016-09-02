require 'cogi_email/version'

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
end
