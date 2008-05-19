class PartyMailer < ActionMailer::Base
  def invite(party, address)
    @subject         = "Invitation to #{party.name}"
    @from            = 'no-reply@example.com'
    @recipients      = address
    @sent_on         = Time.now
    @body['party']   = party
    @body['url']     = party_url party, :host => 'localhost:3000'
    @body['address'] = address
  end
end
