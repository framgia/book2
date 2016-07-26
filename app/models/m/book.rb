class M::Book < ActiveRecord::Base
  UPDATABLE_ATTRS = [:name, :isbn]
  has_many :products
  has_many :purchase_requests

  validates :name, presence: true
  validates :isbn, presence: true, uniqueness: true

  scope :refer_to_m_book, ->name, isbn do
    find_or_create_by name: name, isbn: isbn
  end

  def requested_by? user
    PurchaseRequest.by_user_book(user.id, self.id).present?
  end
end
