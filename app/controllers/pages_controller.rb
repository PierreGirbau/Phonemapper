class PagesController < ApplicationController
  #skip_before_action :authenticate_user!, only: [:home]
  def home
    @products = Product.where(color: "unknown")
  end
end
