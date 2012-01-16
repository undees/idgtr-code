class GuestsController < ApplicationController
  # POST /guests
  def create
    party_permalink = params[:guest].delete :party_permalink
    party = Party.find_by_permalink party_permalink
    @guest = Guest.new(params[:guest].merge :party_id => party.id)

    if @guest.save
      redirect_to @guest.party, :notice => 'You have successfully RSVPed.'
    else
      redirect_to @guest.party
    end
  end
end
