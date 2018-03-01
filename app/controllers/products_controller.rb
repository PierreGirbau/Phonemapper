class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.where(color: "unknown")
  end

  def show
    @ads = Ad.where(product: @product).order('price asc')
  end

    private

  def set_product
    @product = Product.find(params[:id])
  end
end
