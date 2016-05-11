require 'socket'
require 'email_interceptor/version'

class EmailInterceptor
  def initialize(strategy, opts={})
    strategies = [:live, :internal_only, :fake]
    @strategy = strategies.include?(strategy) ? strategy : :fake
    @fake_email_address = opts[:fake_email_address] || 'fake@example.com'
    @internal_recipient_matcher = opts[:internal_recipient_matcher]
    @logger_file = opts[:logger_file]
  end

  def delivering_email(message)
    override_mail_to(message)
    log_delivery(message)
  end

  def override_mail_to(message)
    unless @strategy == :live
      message.to = message.to.map { |t| override_single_recipient(t) }
    end
  end

  def log_delivery(message)
    return unless @logger_file
    File.open(@logger_file, 'a') do |f|
      f.puts "#{Time.now}\n#{message}"
    end
  end

  def override_single_recipient(recipient)
    case @strategy
    when :internal_only
      recipient =~ @internal_recipient_matcher ? recipient : @fake_email_address
    when :live
      recipient
    else # :fake or otherwise
      @fake_email_address
    end
  end
end
