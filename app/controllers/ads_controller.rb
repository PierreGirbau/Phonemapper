class AdsController < ApplicationController
  before_action :set_ad, only: [:show]

  def index
    if params[:query].present?
      @ads = Ad.search_by_title(params[:query]).page params[:page]
    else
      @ads = Ad.all.limit(50).order('price asc').page params[:page]
    end
    @ads_marker = ad_geocoding(@ads)
  end

  def show
    @pictures = Picture.where(ad: @ad)
  end

  private

  def set_ad
    @ad = Ad.find(params[:id])
  end

  def ad_geocoding(ads)
    @ads_marker = Ad.where.not(latitude: nil, longitude: nil)
    @markers = @ads.map do |ad|
      {
        lat: ad.latitude,
        lng: ad.longitude,
      }
    end
    return @markers
  end

end
