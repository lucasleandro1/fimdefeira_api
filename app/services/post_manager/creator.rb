module PostManager
  class Creator
    attr_reader :supermarket, :post_params

    def initialize(supermarket, post_params)
      @supermarket = supermarket
      @post_params = post_params
    end

    def call
      return response_error("Produto ou filial não encontrados") unless valid_product_and_branch?

      if post_exists
        response_error("activerecord.errors.messages.post_exists")
      else
        response(create_post)
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(data)
      { success: true, message: "activerecord.messages.post_created", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end

    def post_exists
      supermarket.posts.exists?(product_id: post_params[:product_id])
    end

    def valid_product_and_branch?
      supermarket.products.exists?(id: post_params[:product_id]) &&
        supermarket.branches.exists?(id: post_params[:branch_id])
    end

    def create_post
      post = supermarket.posts.new(post_params)
      if post.save
        post
      else
        raise StandardError, post.errors.full_messages.to_sentence
      end
    end
  end
end
