class PagesController < ApplicationController
  #skip_before_action :authenticate_user!, only: [:home]
  def home
    #@products = Product.all.page params[:page]
    @ads = Ad.all.limit(9)
  end
end
