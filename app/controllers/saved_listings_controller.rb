class SavedListingsController < ApplicationController

  def index
    @listings = SavedListing.all

    render :index
  end
end
