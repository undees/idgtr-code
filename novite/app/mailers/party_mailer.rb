class PartyMailer < ActionMailer::Base
  def invite(party, address)
    @party      = party
    @address    = address

    @subject    = "Invitation to #{@party.name}"
    @from       = 'no-reply@example.com'
    @recipients = address
    @sent_on    = Time.now
    @url        = party_url @party, :host => 'localhost:3000'
  end
end
