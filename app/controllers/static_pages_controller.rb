class StaticPagesController < ApplicationController

  def root
    render :root
  end

  def zillow
    Listing.destroy_listings
    Listing.fetch_zillow

    @listings = Listing.all
    render :zillow
  end

  def corcoran
    Listing.destroy_listings
    Listing.fetch_corcoran

    @listings = Listing.all
    render :corcoran
  end

end
