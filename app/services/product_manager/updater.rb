module ProductManager
  class Updater
    attr_reader :product_params, :product_id, :supermarket

    def initialize(product_id, product_params, supermarket)
      @product_id = product_id
      @product_params = product_params
      @supermarket = supermarket
    end

    def call
      response(scope)
    rescue ActiveRecord::RecordNotFound => e
      response_error("activerecord.errors.messages.product_notfound: #{e.message}")
    rescue StandardError => error
      response_error(error)
    end

    private

    def response(data)
      { success: true, message: "activerecord.errors.messages.product_update.", resources: data }
    end

    def response_error(error)
      { success: false, error_message: error.message }
    end

    def scope
      @product = supermarket.products.find_by(id: product_id)
      if @product.nil?
        raise ActiveRecord::RecordNotFound, "Product not found for this supermarket"
      end
      unless @product.update(product_params)
        raise StandardError.new(@product.errors.full_messages.to_sentence)
      end
    end
  end
end
