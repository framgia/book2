class M::Book < ActiveRecord::Base
  include M::BookDecorator
  UPDATABLE_ATTRS = [:name, :isbn]
  has_many :products
  has_many :purchase_requests

  validates :name, presence: true
  validates :isbn, presence: true, numericality: true

  def requested_by? user
    PurchaseRequest.by_user_book(user.id, self.id).present?
  end

  class << self
    def create_new_book name, isbn
      isbn = remove_hyphen isbn
      if valid_length? isbn
        convert_to_isbn13 isbn
        find_or_create_book name, isbn
      else
        new name: name, isbn: isbn
      end
    end

    private
    def convert_to_isbn13 isbn
      return isbn if isbn.blank? || isbn.length == 13
      isbn_base = "978#{isbn[0..8]}"
      check_digit = 0
      isbn_base.split(//).each_with_index do |chr, idx|
        check_digit += chr.to_i * (idx.even? ? 1 : 3)
      end
      check_digit = (10 - check_digit % 10) % 10
      "#{isbn_base}#{check_digit}"
    end

    def remove_hyphen isbn
      isbn.gsub"-", ""
    end

    def valid_length? isbn
      isbn.length == 13 || isbn.length == 10
    end

    def find_or_create_book name, isbn
      find_by(isbn: isbn) || create(name: name, isbn: isbn)
    end
  end

  def isbn10
    return self.isbn if self.isbn.blank? || self.isbn.length == 10
    isbn_base = self.isbn.gsub("-", "")[3..11]
    return self.isbn if isbn_base.blank?
    check_digit = 0
    isbn_base.split(//).each_with_index do |chr, idx|
      check_digit += chr.to_i * (10 - idx)
    end
    check_digit = 11 - check_digit % 11
    case check_digit
    when 10
      check_digit = "X"
    when 11
      check_digit = 0
    end
    "#{isbn_base}#{check_digit}"
  end
end
