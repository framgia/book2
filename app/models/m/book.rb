class M::Book < ActiveRecord::Base
  include M::BookDecorator
  UPDATABLE_ATTRS = [:name, :isbn]
  has_many :products
  has_many :purchase_requests

  validates :name, presence: true
  validates :isbn, presence: true, uniqueness: true

  def requested_by? user
    PurchaseRequest.by_user_book(user.id, self.id).present?
  end

  class << self
    def create_new_book name, isbn
      find_by(isbn: isbn) || create(name: name, isbn: isbn)
    end
  end

  def isbn13
    return self.isbn if self.isbn.blank? || self.isbn.length == 13
    isbn_base = "978#{self.isbn[0..8]}"
    check_digit = 0
    isbn_base.split(//).each_with_index do |chr, idx|
      check_digit += chr.to_i * (idx.even? ? 1 : 3)
    end
    check_digit = (10 - (check_digit % 10)) % 10
    "#{isbn_base}#{check_digit}"
  end

  def isbn10
    return self.isbn if self.isbn.blank? || self.isbn.length == 10
    isbn_base = self.isbn[3..11]
    return self.isbn if isbn_base.blank?
    check_digit = 0
    isbn_base.split(//).each_with_index do |chr, idx|
      check_digit += chr.to_i * (10 - idx)
    end
    check_digit = 11 - (check_digit % 11)
    case check_digit
    when 10
      check_digit = "X"
    when 11
      check_digit = 0
    end
    "#{isbn_base}#{check_digit}"
  end
end
