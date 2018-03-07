
class PagesController < ApplicationController
  #skip_before_action :authenticate_user!, only: [:home]
  def home
    if @geolocation.first.latitude && @geolocation.first.longitude
      @ads = Ad.near([@geolocation.first.latitude, @geolocation.first.longitude], 20).limit(12)
      gmaps = GoogleMapsService::Client.new(key: ENV['GOOGLE_API_SERVER_KEY'])
      user_location = [@geolocation.first.latitude, @geolocation.first.longitude]
      @travel_time = {}

      @ads.each do |ad|
        route = gmaps.directions(user_location, ad.location,
                mode: 'driving',
                alternatives: false)

        time = route.first[:legs].first[:duration][:text]

        @travel_time[ad.id] = time
          #TODO iterate on ads and call Gmaps direction API
          #routes = gmaps.directions(
          #'1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA',
          #'2400 Amphitheatre Parkway, Mountain View, CA 94043, USA',
          #mode: 'walking',
          #alternatives: false)
          # build a hash { 12: "5mins", 13: "7mins"}
     end
    return @ads

    end
    @ads = Ad.all.limit(12)
  end
end
