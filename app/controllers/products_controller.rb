class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :destroy]

  # GET /products
  # GET /products.json
  def index
    if params[:user_id]
      @products = Product.user_products user_id_params
      render 'products/user_index'
    else
      @products = Product.all.includes [:m_book, :borrowing_histories, :reservations]
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  def new
    @purchase_request = PurchaseRequest.find params[:purchase_request_id]
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      redirect_to purchase_requests_path
    else
      render :new
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:purchase_date, :m_branch_id, :price, :m_book_id, :purchase_request_id)
  end

  def user_id_params
    params[:user_id]
  end
end
