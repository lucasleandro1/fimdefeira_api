module ProductManager
  class Destroyer
    attr_reader :product_id, :supermarket, :branch

    def initialize(product_id, supermarket, branch)
      @product_id = product_id
      @supermarket = supermarket
      @branch = branch
    end

    def call
      response(scope)
    rescue StandardError => error
      response_error(error)
    end

    private

    def response(data)
      { success: true, message: I18n.t("activerecord.errors.messages.product_delete"), resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end

    def scope
      @product = supermarket.products.find_by(id: product_id, branch: @branch)
      if @product.nil?
        raise ActiveRecord::RecordNotFound, "Product not found for this supermarket and branch"
      end
      unless @product.destroy
        raise StandardError.new(@product.errors.full_messages.to_sentence)
      end
      @product
    end
  end
end
