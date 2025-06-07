module ProductManager
  class Finder
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
      { success: true, resources: data }
    end

    def response_error(error)
      { success: false, error_message: error.message }
    end

    def scope
      supermarket.products.find_by(id: product_id, branch: @branch)
    end
  end
end
