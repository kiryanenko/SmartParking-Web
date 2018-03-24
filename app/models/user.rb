class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sensors

  def self.authenticate(login, password)
    user = find_for_authentication(:email => login)
    user.valid_password?(password) ? user : nil
  end

  def self.authenticate!(login, password)
    user = authenticate login, password
    raise AuthenticationFail 'Authentication failed' if user.nil?
    user
  end

  class AuthenticationFail < StandardError
  end
end
