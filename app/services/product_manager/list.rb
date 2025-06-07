module ProductManager
  class List
    attr_reader :supermarket, :branch

    def initialize(supermarket, branch)
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
      @supermarket.products.where(branch: @branch)
    end
  end
end
