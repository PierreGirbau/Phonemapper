class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #before_action :authenticate_user!
  before_action :geolocate_ip

  def geolocate_ip
    ip = request.remote_ip
    if ip == "127.0.0.1"
      return @geolocation =  Geocoder.search('89.3.76.191')
    end
    @geolocation = Geocoder.search(ip)
  end
end
