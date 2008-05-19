class GuestsController < ApplicationController
  # POST /guests
  # POST /guests.xml
  def create
    party_permalink = params[:guest].delete :party_permalink
    party = Party.find_by_permalink party_permalink
    @guest = Guest.new(params[:guest].merge :party_id => party.id)

    respond_to do |format|
      if @guest.save
        flash[:notice] = 'You have successfully RSVPed.'
        format.html { redirect_to(@guest.party) }
        format.xml  { render :xml => @guest, :status => :created, :location => @guest }
      else
        format.html { redirect_to(@guest.party) }
        format.xml  { render :xml => @guest.errors, :status => :unprocessable_entity }
      end
    end
  end
end
