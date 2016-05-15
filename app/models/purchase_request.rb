class PurchaseRequest < ActiveRecord::Base
  UPDATABLE_ATTRS = %i(m_book_id user_id state)

  validates :user_id, :m_book_id, presence: true

  belongs_to :m_book
  belongs_to :user
  enum state: {waiting: 0, accepted: 1, nonaccepted: 2}

  scope :by_user_book, ->user_id, m_book_id { where(user_id: user_id,
    m_book_id: m_book_id)}

  after_update :create_product_if_accepted

  def create_product_if_accepted
    if state.intern == :accepted
      Product.create m_book_id: m_book_id
    end
  end
end
