module ProductManager
  class Updater
    attr_reader :product_params, :product_id

    def initialize(product_id, product_params)
      @product_id = product_id
      @product_params = product_params
    end

    def call
      response(scope)
    rescue ActiveRecord::RecordNotFound => e
      response_error(I18n.t("activerecord.errors.messages.product_notfound: #{e.message}"))
    rescue StandardError => error
      response_error(error)
    end

    private

    def response(data)
      { success: true, message: I18n.t("activerecord.errors.messages.product_update."), resources: data }
    end

    def response_error(error)
      { success: false, error_message: error.message }
    end

    def scope
      @product = Product.find(product_id)
      unless @product.update(product_params)
        raise StandardError.new(product.errors.full_messages.to_sentence)
      end
    end
  end
end
