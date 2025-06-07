module ProductManager
  class Finder
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
      { success: true, resources: data }
    end

    def response_error(error)
      { success: false, error_message: error.message }
    end

    def scope
      supermarket.products.find_by(id: product_id)
    end
  end
end
