module PostManager
  class Destroyer
    attr_reader :post_id

    def initialize(post_id)
      @post_id = post_id
    end

    def call
      response(scope)
    rescue StandardError => error
      response_error(error)
    end

    private

    def response(data)
      { success: true, message: "activerecord.errors.messages.post_delete", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end

    def scope
      @post = Post.find(post_id)
      unless @post.destroy
        raise StandardError.new(product.errors.full_messages.to_sentence)
      end
    end
  end
end
