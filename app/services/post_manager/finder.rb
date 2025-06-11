module PostManager
  class Finder
    attr_reader :post_id, :user, :branch_id

    def initialize(post_id, user, branch_id)
      @post_id = post_id
      @user = user
      @branch_id = branch_id
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
      if user.is_a?(Supermarket)
        Post.includes(:product, :supermarket, :branch)
            .where(id: post_id, branch_id: branch_id)
            .first
      elsif user.is_a?(Client)
        Post.includes(:product, :supermarket, :branch).find_by(id: post_id)
      else
        nil
      end
    end
  end
end
