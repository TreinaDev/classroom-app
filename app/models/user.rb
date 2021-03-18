class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo

  validates :name, presence: true
  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@smartflix\.com\.br\z/,
                              message: 'Email precisa ser da empresa SmartFlix' }
end
