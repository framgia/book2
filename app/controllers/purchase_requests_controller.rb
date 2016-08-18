class PurchaseRequestsController < ApplicationController
  before_action :set_purchase_request, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @purchase_requests = PurchaseRequest.sort_list
  end

  def new
    @m_book = ::M::Book.new
    @purchase_request = ::PurchaseRequest.new
  end

  def edit
  end

  def create
    set_requestor
    @purchase_request = ::PurchaseRequest.new(purchase_request_params)
    if @purchase_request.save
      redirect_to ({action: "index"}), notice: "Purchase request was successfully created."
    else
      @m_book = @purchase_request.m_book
      render :new
    end
  end

  def update
    if @purchase_request.update(purchase_request_params)
      redirect_to purchase_requests_path, notice: "Purchase request was successfully updated."
    else
      render :index
    end
  end

  def destroy
    @purchase_request.destroy
    redirect_to purchase_requests_url, notice: "Purchase request was successfully destroyed."
  end

  private
  def set_purchase_request
    @purchase_request = ::PurchaseRequest.find params[:id]
  end

  def purchase_request_params
    params.require(:purchase_request).permit ::PurchaseRequest::UPDATABLE_ATTRS
  end

  def set_requestor
    params[:purchase_request][:user_id] = current_user.id
  end
end
