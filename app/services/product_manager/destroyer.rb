module ProductManager
  class Destroyer
    attr_reader :product_id, :supermarket

    def initialize(product_id, supermarket)
      @product_id = product_id
      @supermarket = supermarket
    end

    def call
      response(scope)
    rescue StandardError => error
      response_error(error)
    end

    private

    def response(data)
      { success: true, message: "activerecord.errors.messages.product_delete", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end

    def scope
      @product = supermarket.products.find_by(id: product_id)
      if @product.nil?
        raise ActiveRecord::RecordNotFound, "Product not found for this supermarket"
      end
      unless @product.destroy
        raise StandardError.new(@product.errors.full_messages.to_sentence)
      end
    end
  end
end
