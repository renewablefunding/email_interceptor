require 'stringio'
require 'ostruct'
require 'spec_helper'

describe EmailInterceptor do
  let(:opts) { {:fake_email_address => 'foo@bar.com', :internal_recipient_matcher => /@renewfund.com$/, :logger_file => '/foo/bar/mail.log' } }
  subject(:fake_interceptor) { described_class.new(:fake, opts) }
  subject(:live_interceptor) { described_class.new(:live, opts) }
  subject(:internal_interceptor) { described_class.new(:internal_only, opts) }
  subject(:bogus_interceptor) { described_class.new(:bogus, opts) }

  describe '#delivering_email' do
    it 'overrides mail to and logs delivery' do
      subject.should_receive(:override_mail_to).with(:message)
      subject.should_receive(:log_delivery).with(:message)
      subject.delivering_email(:message)
    end
  end

  describe '#override_mail_to' do
    it 'always fake mail recipients when strategy is fake' do
      message = OpenStruct.new(:to => ['real@email.address', 'real@renewfund.com'])
      fake_interceptor.override_mail_to(message)
      expect(message.to).to eq ['foo@bar.com', 'foo@bar.com']
    end

    it 'only fakes external mail recipients when strategy is internal_only' do
      message = OpenStruct.new(:to => ['real@email.address', 'real@renewfund.com'])
      internal_interceptor.override_mail_to(message)
      expect(message.to).to eq ['foo@bar.com', 'real@renewfund.com']
    end

    it 'does not modify mail to address if strategy is live' do
      message = OpenStruct.new(:to => ['real@email.address', 'real@renewfund.com'])
      live_interceptor.override_mail_to(message)
      expect(message.to).to eq ['real@email.address', 'real@renewfund.com']
    end

    it 'fakes the recipient if the strategy is not live, internal_only, or fake' do
      message = OpenStruct.new(:to => ['real@email.address', 'real@renewfund.com'])
      bogus_interceptor.override_mail_to(message)
      expect(message.to).to eq ['foo@bar.com', 'foo@bar.com']
    end
  end

  describe '#log_delivery' do
    it 'adds the message to the mailer log' do
      io = StringIO.new(dummy_file = '')
      File.stub(:open).with('/foo/bar/mail.log', 'a').and_yield(io)
      Time.stub(:now => 'alabaster')
      subject.log_delivery('nergo nergo')
      dummy_file.split("\n").should == ["alabaster", "nergo nergo"]
      Time.unstub(:now)
    end
  end

  describe '#override_single_recipient' do
    context ':internal_only' do
      it { expect( internal_interceptor.override_single_recipient('bob@renewfund.com')).to eq 'bob@renewfund.com' }
      it { expect( internal_interceptor.override_single_recipient('bob@home.com')).to eq 'foo@bar.com' }
    end

    context ':live' do
      it { expect( live_interceptor.override_single_recipient('bob@home.com')).to eq 'bob@home.com' }
      it { expect( live_interceptor.override_single_recipient('bob@renewfund.com')).to eq 'bob@renewfund.com' }
    end

    context ':fake' do
      it { expect( fake_interceptor.override_single_recipient('bob@home.com')).to eq 'foo@bar.com' }
      it { expect( fake_interceptor.override_single_recipient('bob@renewfund.com')).to eq 'foo@bar.com' }
    end


    context 'else' do
      it { expect( bogus_interceptor.override_single_recipient('bob@home.com')).to eq 'foo@bar.com' }
      it { expect( bogus_interceptor.override_single_recipient('bob@renewfund.com')).to eq 'foo@bar.com' }
    end
  end
end
