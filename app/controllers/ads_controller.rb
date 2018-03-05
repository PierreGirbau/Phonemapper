class AdsController < ApplicationController
  before_action :set_ad, only: [:show]

  def index
    if params[:query].present?
      @ads = Ad.search_by_title(params[:query])
    else
      @ads = Ad.all.limit(50).order('price asc')
    end
  end

  def show
    @pictures = Picture.where(ad: @ad)
  end

  private

  def set_ad
    @ad = Ad.find(params[:id])
  end
end
