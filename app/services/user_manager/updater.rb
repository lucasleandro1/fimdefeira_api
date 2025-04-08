module UserManager
  class Updater
    def self.call(user, params)
      allowed_params = %i[name address telephone]
      allowed_params << :cnpj if user.supermercado?
      user.update!(params.slice(*allowed_params))
      user
    end
  end
end
