require 'open-uri'
require 'addressable/uri'

class Listing < ActiveRecord::Base

  def self.fetch_zillow
    zillow = Nokogiri::XML(open("http://www.related.com/feeds/ZillowAvailabilities.xml"))
    address_arr = []
    listings = zillow.xpath("//Listings//Listing//Location")

    listings.each do |listing|

      street = listing.xpath("StreetAddress")[0].content
      city = listing.xpath("City")[0].content
      state = listing.xpath("State")[0].content
      zip = listing.xpath("Zip")[0].content

      address_arr << [street, city, state, zip]

    end

    Listing.transaction do
      address_arr.each do |listing|
        Listing.create!(
          street: listing[0],
          city: listing[1],
          state: listing[2],
          zip: listing[3]
        )
      end
    end
    nil
  end

  def self.fetch_corcoran
    mech = Mechanize.new
    corcoran_page = mech.get('http://www.corcoran.com/nyc/Search/Listings?SaleType=Rent')
    listings = corcoran_page.search('div.listing')
    streets_arr = []


    listings.each do |listing|
      street = listing.search("span.address")[0].search('a')[0].attr('title').split(',')[0]
      city = listing.search("span.neighborhood")[0].search('a')[0].content

      streets_arr << [street, city]
    end

    while listings.count == 24
      corcoran_page = corcoran_page.link_with(text: 'Next').click
      listings = corcoran_page.search('div.listing')

      listings.each do |listing|
        street = listing.search("span.address")[0].search('a')[0].attr('title').split(',')[0]
        city = listing.search("span.neighborhood")[0].search('a')[0].content

        streets_arr << [street, city]
      end
    end

    Listing.transaction do
      streets_arr.each do |listing|
        Listing.create!(
          street: listing[0],
          city: listing[1],
          state: 'NYC',
          zip: ''
        )
      end
    end
    nil
  end

  def self.destroy_listings
    Listing.transaction do
      Listing.destroy_all
    end
    nil
  end

  def get_lat_long
    addr = self.street + ', ' + self.city + ', ' + self.state + ', ' + self.zip

    google_url = Addressable::URI.new(
      scheme: "https",
      host: "maps.googleapis.com",
      path: "maps/api/geocode/json",
      query_values: {
        address: addr
      }
    ).to_s

    response = RestClient.get(google_url)
    parsed_response = JSON.parse(response)
    latitude = parsed_response["results"].first["geometry"]["location"]["lat"]
    longitude = parsed_response["results"].first["geometry"]["location"]["lng"]

    latitude.to_s + ', ' + longitude.to_s

  end

end
