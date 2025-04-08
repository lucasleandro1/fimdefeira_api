module ProductManager
  class Creator
    attr_reader :user, :product_params

    def initialize(user, product_params)
      @user = user
      @product_params = product_params
    end

    def call
      if product_exists
        response_error(message: "activerecord.errors.messages.product_exists")
      else
        response(create_product)
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(data)
      { success: true, message: "activerecord.messages.product_created", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end

    def product_exists
      user.products.exists?(name: product_params[:name])
    end

    def create_product
      product = user.products.new(product_params)
      if product.save
        product
      else
        raise StandardError, product.errors.full_messages.to_sentence
      end
    end
  end
end
