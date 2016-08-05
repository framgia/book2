class User < ActiveRecord::Base
  include UserDecorator

  has_many :purchase_requests
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :omniauthable, omniauth_providers: [:github]
  attr_accessor :email

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.nickname = auth.info.nickname
      auth.info.email == nil ? dummy_email(auth) : user.email = auth.info.email
      user.image = auth.info.image
      user.email = auth.info.email || dummy_email(auth)
      user.github_url = auth.info.urls["GitHub"]
      user.blog_url = auth.info.urls["Blog"]
    end
  end

  # allow users to update their accounts without passwords
  def update_without_current_password(params, *options)
    params.delete(:current_password)
 
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
 
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def password_required?
    super && provider.blank?
  end

  def email_required?
    super && provider.blank?
  end

  def admin?
    Settings.users.admins.include? self.nickname
  end

  class << self
    private
    def dummy_email auth
      auth.info.nickname + "@dummy"
    end
  end
end
