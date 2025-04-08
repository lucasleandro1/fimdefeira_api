module PostManager
  class Creator
    attr_reader :user, :post_params

    def initialize(user, post_params)
      @user = user
      @post_params = post_params
    end

    def call
      if post_exists
        response_error(message: "activerecord.errors.messages.post_exists")
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
      user.posts.exists?(name: post_params[:name])
    end

    def create_post
      post = user.Posts.new(post_params)
      if post.save
        post
      else
        raise StandardError, post.errors.full_messages.to_sentence
      end
    end
  end
end
