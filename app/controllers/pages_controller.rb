class PagesController < ApplicationController
  #skip_before_action :authenticate_user!, only: [:home]
  def home
    #@products = Product.all.page params[:page]
    if @geolocation.first.latitude && @geolocation.first.longitude
     return @ads = Ad.near([@geolocation.first.latitude, @geolocation.first.longitude], 20).limit(9)
    end
    @ads = Ad.all.limit(9)

    # @geolocation use .near de Geocoding

  end
end
