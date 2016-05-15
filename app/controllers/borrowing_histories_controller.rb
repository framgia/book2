class BorrowingHistoriesController < ApplicationController
  before_action :set_borrowing_history, only: [:show, :edit, :update, :destroy]

  # GET /borrowing_histories
  # GET /borrowing_histories.json
  def index
    @borrowing_histories = BorrowingHistory.all
  end

  # GET /borrowing_histories/1
  # GET /borrowing_histories/1.json
  def show
  end

  # GET /borrowing_histories/new
  def new
    @borrowing_history = BorrowingHistory.new
  end

  # GET /borrowing_histories/1/edit
  def edit
  end

  # POST /borrowing_histories
  def create
    @borrowing_history = BorrowingHistory.create! product_id: params[:product_id],
      borrower_id: current_user, borrowed_at: Time.now
    redirect_to products_path, notice: "Product was successfully borrowed."
  end

  # PATCH/PUT /borrowing_histories/1
  def update
    @borrowing_history.returned_at = Time.now
    @borrowing_history.save!
    product = @borrowing_history.product
    reservation = product.reservations.try :first
    unless reservation.nil?
      BorrowingHistory.create! product_id: product.id,
        borrower_id: reservation.reserved_user_id, borrowed_at: Time.now
      Notification.create! subject: "[Return Book Notification] #{product.name} was returned.",
        description: "Your book : #{product.name}",
        sender_id: @borrowing_history.borrower_id, receiver_id: reservation.reserved_user_id
      reservation.destroy!
    end
    redirect_to products_path, notice: "Product was successfully returned."
  end

  # DELETE /borrowing_histories/1
  # DELETE /borrowing_histories/1.json
  def destroy
    @borrowing_history.destroy
    respond_to do |format|
      format.html { redirect_to borrowing_histories_url, notice: 'Borrowing history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_borrowing_history
      @borrowing_history = BorrowingHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def borrowing_history_params
      params.require(:borrowing_history).permit(:borrower_id, :product_id, :borrowed_at, :return_untill, :returned_at)
    end
end
