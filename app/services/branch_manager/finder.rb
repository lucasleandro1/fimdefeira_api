module ProductManager
  class Finder
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
      { success: true, resources: data }
    end

    def response_error(error)
      { success: false, error_message: error.message }
    end

    def scope
      Product.find(product_id)
    end
  end
end
