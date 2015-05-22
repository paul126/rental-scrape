#reset

SavedListing.destroy_all
Listing.destroy_listings

Listing.fetch_corcoran
Listing.fetch_zillow


listings = Listing.all


listings.each do |listing|
  coords = listing.get_lat_long

  lat = coords.split(', ')[0]
  lon = coords.split(', ')[1]

  SavedListing.create!(
    street: listing.street,
    city: listing.city,
    state: listing.state,
    zip: listing.zip,
    latitude: lat,
    longitude: lon
  )

  sleep(0.2)

end
