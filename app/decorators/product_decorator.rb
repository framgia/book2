module ProductDecorator
  BOOK_IMAGE_URL_FMT = "http://images-jp.amazon.com/images/P/%s.09.TZZZZZZZ.jpg"
  def name
    m_book ? m_book.name : ""
  end
  def book_image_path
    m_book ? BOOK_IMAGE_URL_FMT % m_book.isbn10 : ""
  end
end
