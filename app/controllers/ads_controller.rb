class AdsController < ApplicationController
  before_action :set_ad, only: [:show]

  def index
    @sources = Ad.distinct.order(:source).pluck(:source)

    if params[:query].present?
      geocoded_results = Ad.near([@geolocation.first.latitude, @geolocation.first.longitude], 20).limit(100)
      @ads = geocoded_results.search_by_title(params[:query]).order('price asc')
    else
      @ads = Ad.all.limit(100).order('price asc')
    end

    if params[:price].present?
      @ads = @ads.where(price: 0..params[:price].to_i)
    end

    if params[:capacity].present?
      @ads = @ads.where("title ILIKE ?", "%#{params[:capacity]}%")
      # @ads = @ads.includes(:product).where(products: { capacity: params[:capacity].to_i })
    end

    if params[:source].present?
      @ads = @ads.where(source: params[:source])
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
        id: ad.id,
        lat: ad.latitude,
        lng: ad.longitude,
      }
    end
    return @markers
  end

end
