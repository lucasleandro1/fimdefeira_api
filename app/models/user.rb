class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { supermercado: 0, cliente: 1 }

  has_many :branches
  has_many :products
  has_many :posts
  has_many :tickets
  has_many :sales, class_name: "Ticket", foreign_key: "store_id"
end
