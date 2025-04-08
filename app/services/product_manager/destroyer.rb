module ProductManager
  class Destroyer
    attr_reader :product_id

    def initialize(product_id)
      @product_id = product_id
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
      @product = Product.find(product_id)
      unless @product.destroy
        raise StandardError.new(product.errors.full_messages.to_sentence)
      end
    end
  end
end
