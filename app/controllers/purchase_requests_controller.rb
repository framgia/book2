class PurchaseRequestsController < ApplicationController
  before_action :set_purchase_request, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :find_or_create_book, only: :create

  def index
    @m_books = ::M::Book.all
  end

  def show
  end

  def new
    @m_book = ::M::Book.new
    @purchase_request = ::PurchaseRequest.new
  end

  def edit
  end

  def create
    @purchase_request = ::PurchaseRequest.new(purchase_request_params)
    respond_to do |format|
      if @purchase_request.save
        format.js {}
        format.html do
         redirect_to @purchase_request, notice: 'Purchase request was successfully created.'
        end
      else
        format.html do
          @m_book = ::M::Book.new
          render :new
        end
        format.json { render json: @purchase_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @purchase_request.update(purchase_request_params)
        format.html { redirect_to @purchase_request, notice: 'Purchase request was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase_request }
      else
        format.html { render :edit }
        format.json { render json: @purchase_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @purchase_request.destroy
    respond_to do |format|
      format.html { redirect_to purchase_requests_url, notice: 'Purchase request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_purchase_request
    @purchase_request = ::PurchaseRequest.find(params[:id])
  end

  def purchase_request_params
    params.require(:purchase_request).permit(::PurchaseRequest::UPDATABLE_ATTRS)
  end

  def find_or_create_book
    if params[:purchase_request][:m_book_id].blank?
      new_book = M::Book.find_or_create_by(params[:m_book].permit(::M::Book::UPDATABLE_ATTRS))
      params[:purchase_request][:m_book_id] = new_book.id if new_book.id
    end
  end
end
