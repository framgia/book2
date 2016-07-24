class PurchaseRequest < ActiveRecord::Base
  UPDATABLE_ATTRS = %i(m_book_id user_id state).concat M::Book::UPDATABLE_ATTRS
  attr_accessor :name, :isbn

  enum state: {waiting: 0, accepted: 1, nonaccepted: 2}

  belongs_to :m_book, class_name: M::Book.name
  belongs_to :user

  before_validation :fetch_book
  after_update :create_product_if_accepted

  validates :user_id, :m_book_id, presence: true

  scope :by_user_book, ->user_id, m_book_id do
    where user_id: user_id, m_book_id: m_book_id
  end

  def state_is? _state
    state.intern == _state.intern
  end

  private
  def fetch_book
    self.m_book = M::Book.refer_to_m_book name, isbn
  end

  def create_product_if_accepted
    return unless self.state_is? :accepted
    Product.create m_book_id: m_book_id
  end
end
