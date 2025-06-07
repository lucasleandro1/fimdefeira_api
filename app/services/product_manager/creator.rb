module ProductManager
  class Creator
    attr_reader :supermarket, :branch, :product_params

    def initialize(supermarket, branch, product_params)
      @supermarket = supermarket
      @branch = branch
      @product_params = product_params
    end

    def call
      return response_error("Branch not found") if branch.nil?

      if product_exists?
        response_error(I18n.t("activerecord.errors.messages.product_exists"))
      else
        response(create_product)
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(data)
      {
        success: true,
        message: I18n.t("activerecord.messages.product_created"),
        resource: data
      }
    end

    def response_error(error)
      {
        success: false,
        error_message: error
      }
    end

    def product_exists?
      supermarket.products.exists?(name: product_params[:name], branch_id: branch.id)
    end

    def create_product
      product = supermarket.products.new(product_params.merge(branch_id: branch.id))
      product.save!
      product
    end
  end
end
