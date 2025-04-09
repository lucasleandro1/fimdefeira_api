class Supermarket < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :branches
  has_many :products
  has_many :posts
  has_many :tickets

  def jwt_subject
    id
  end
end
