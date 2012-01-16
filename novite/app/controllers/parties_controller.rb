class PartiesController < ApplicationController
  # GET /parties
  def index
    redirect_to new_party_path
  end

  # GET /parties/1
  def show
    @party = Party.find_by_permalink(params[:id])

    guest_name = params[:accept] || params[:decline]
    if guest_name
      guest = Guest.new \
        :party_id => @party.id,
        :name => guest_name,
        :attending => params.has_key?(:accept)
      guest.save
    end

    respond_to do |format|
      format.html # show.html.erb
      format.text do
        email = PartyMailer.invite @party, params[:email]
        render :text => email.encoded
      end
    end
  end

  # GET /parties/new
  def new
    @party = Party.new
  end

  # POST /parties
  def create
    @party = Party.new(params[:party])

    if @party.save
      recipients = params[:recipients]

      if !recipients || recipients.empty?
        redirect_to @party, :notice => "Paste the text below into your e-mail program."
      else
        recipients.split(',').each do |address|
          email = PartyMailer.invite(@party, address.strip).deliver
        end

        redirect_to @party, :notice => "Invitations successfully sent to #{recipients}."
      end
    else
      render :action => 'new'
    end
  end
end
