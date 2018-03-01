class AdsController < ApplicationController
  before_action :set_ad, only: [:show]

  def index
    @ads = Ad.all.limit(50).order('price asc')
  end

  def show
    @pictures = Picture.where(ad: @ad)
  end

  private

  def set_ad
    @ad = Ad.find(params[:id])
  end
end
