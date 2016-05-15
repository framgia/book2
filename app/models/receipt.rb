class Receipt < ActiveRecord::Base
  include ReceiptDecorator
  UPDATABLE_ATTRS = [:name, :product_id, :image]
  belongs_to :product

  validates :product_id, presence: true
  validates :image, presence: true

  def image= image
    if image.is_a? ActionDispatch::Http::UploadedFile
      self.image = image.read
      self.original_filename = image.original_filename
      self.content_type = image.content_type
    else
      super image
    end
  end
end