class LoggedExceptionsMailer < ActionMailer::Base

  cattr_accessor :mailer_config
  @@mailer_config = {
    :deliver     => false,
    :subject     => 'Exception',
    :recipients  => "",
    :from        => '',
    :link        => ''
  }

  default :from => mailer_config[:from]

  def exception(e)
    @link = mailer_config[:link]
    @e = e
    sent_on Time.now
    content_type "text/html"
    mail(:to => mailer_config[:recipients], :subject => mailer_config[:subject])
  end
end