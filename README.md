# EmailInterceptor

This is a very simple gem that works as an ActiveMailer email
interceptor.  It allows you to selectively send some emails (called
:internal) while re-writing all other emails with a test account or
other email address.

The intention of this is to prevent real users from being emailed from
non-production environments, such as staging.

## Installation

Add this line to your application's Gemfile:

    gem 'email_interceptor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_interceptor

## Usage

To use this in Rails, one can pass it to
`ActionMailer.register_interceptor` in an initializer, i.e.

```ruby
email_interceptor = EmailInterceptor.new(:internal_only, {
  :fake_email_address => 'testdummy@example.com',
  :internal_recipient_matcher => /@this.can.be.a.regex.com$/,
  :logger_file => Rails.root.join('/log/mailer.log')
})

ActionMailer::Base.register_interceptor(email_interceptor)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
