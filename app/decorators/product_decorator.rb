module ProductDecorator
  def name
    m_book ? m_book.name : ""
  end
end
