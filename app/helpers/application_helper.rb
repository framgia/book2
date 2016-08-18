module ApplicationHelper
  def l(*args)
    I18n.localize(*args) unless args.first.nil?
  end

  def accepted_requests?
    @result ||= PurchaseRequest.accepted_requests.exists?
  end
end
