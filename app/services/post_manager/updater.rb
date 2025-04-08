module PostManager
  class Updater
    attr_reader :post_params, :post_id

    def initialize(post_id, post_params)
      @post_id = post_id
      @post_params = post_params
    end

    def call
      response(scope)
    rescue ActiveRecord::RecordNotFound => e
      response_error("activerecord.errors.messages.post_notfound: #{e.message}")
    rescue StandardError => error
      response_error(error)
    end

    private

    def response(data)
      { success: true, message: "activerecord.errors.messages.post_update.", resources: data }
    end

    def response_error(error)
      { success: false, error_message: error.message }
    end

    def scope
      @post = Post.find(post_id)
      unless @post.update(post_params)
        raise StandardError.new(post.errors.full_messages.to_sentence)
      end
    end
  end
end
