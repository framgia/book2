class ProductsController < ApplicationController
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

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:m_book_id, :status, :requested_date, :request_user_id)
  end

  def user_id_params
    params[:user_id]
  end
end
