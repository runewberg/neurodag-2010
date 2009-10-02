class Notifier < ActionMailer::Base

  def hello_world(sent_at = Time.now)
    @subject    = 'Notifier#hello_world'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end
end
