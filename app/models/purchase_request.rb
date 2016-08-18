class PurchaseRequest < ActiveRecord::Base
  UPDATABLE_ATTRS = %i(m_book_id user_id state).concat M::Book::UPDATABLE_ATTRS
  attr_accessor :name, :isbn

  enum state: {waiting: 0, accepted: 1, nonaccepted: 2}

  belongs_to :m_book, class_name: M::Book.name
  belongs_to :user
  has_one :product

  before_validation :fetch_book, on: :create

  validates :user_id, :m_book_id, presence: true

  scope :by_user_book, ->user_id, m_book_id do
    where user_id: user_id, m_book_id: m_book_id
  end

  scope :sort_list, ->{all.order created_at: :desc}
  scope :accepted_requests, ->{where state: 1}

  def purchased?
    self.product.present?
  end

  private
  def fetch_book
    self.m_book = M::Book.create_new_book name, isbn
  end
end
