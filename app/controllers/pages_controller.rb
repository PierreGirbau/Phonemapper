class PagesController < ApplicationController
  #skip_before_action :authenticate_user!, only: [:home]
  def home
    if @geolocation.first.latitude && @geolocation.first.longitude
     return @ads = Ad.near([@geolocation.first.latitude, @geolocation.first.longitude], 20).limit(12)
    end
    @ads = Ad.all.limit(12)
  end
end
