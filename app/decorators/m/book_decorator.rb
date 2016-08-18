module M::BookDecorator
  BOOK_IMAGE_URL_FMT = "http://images-jp.amazon.com/images/P/%s.09.TZZZZZZZ.jpg"
  def book_image_path
    BOOK_IMAGE_URL_FMT % self.isbn10
  end
end