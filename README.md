# CogiEmail [![Build Status](https://travis-ci.org/hoahm/cogi_email.svg?branch=master)](https://travis-ci.org/hoahm/cogi_email) [![Coverage Status](https://coveralls.io/repos/github/hoahm/cogi_email/badge.svg)](https://coveralls.io/github/hoahm/cogi_email) [![GitHub issues](https://img.shields.io/github/issues/hoahm/cogi_email.svg)](https://github.com/hoahm/cogi_email/issues) [![Gem Version](https://badge.fury.io/rb/cogi_email.svg)](https://badge.fury.io/rb/cogi_email)

This gem provide you library to validate, parsing and format email. Check is email is real or not.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cogi_email'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install cogi_email
```

## Usage

### Validation

Check if a string is a valid email address.

```ruby
CogiEmail.validate? 'nobi.younet@gmail.com' # => true
```


### Normalization

Normalize phone numer to international format.

```ruby
CogiEmail.normalize 'Nobi.younet@gmail.com' # => 'nobi.younet@gmail.com'
CogiEmail.normalize '(Nobi)<nobi.younet@gmail.com>' # => 'nobi.younet@gmail.com'
```

### Validate email domain

Check if email domain is valid by making a DNS lookup.

```ruby
CogiEmail.valid_email_domain? 'nobi.younet@gmail.com' # => true
CogiEmail.valid_email_domain? 'nobi.younet@localhost' # => false
```

### Check if real email

Check if an email address is real or not.

An email address is real if:
  - Is valid
  - Has MX DNS record
  - Can send a test email

```ruby
CogiEmail.real_email? 'nobi.younet@gmail.com' # => true
CogiEmail.real_email? 'nobi.younet@localhost' # => false
```

## Credit

Thank you [Kamil Ciemniewski](https://github.com/kamilc) so much for writing [email_verifier](https://github.com/kamilc/email_verifier) gem. I reference his gem to re-writing email checker for this gem.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Don't forget to add tests and run rspec before creating a pull request :)

See all contributors on https://github.com/hoahm/cogi_email/graphs/contributors.
