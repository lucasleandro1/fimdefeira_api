class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api

  has_many :tickets

  def current_discount
    return 5 if cupons.nil? || cupons <= 0

    discount = cupons * 5
    discount > 50 ? 5 : discount
  end

  def increment_cupons!
    if current_discount >= 50
      update!(cupons: 1)
    else
      update!(cupons: (cupons || 0) + 1)
    end
  end
end
