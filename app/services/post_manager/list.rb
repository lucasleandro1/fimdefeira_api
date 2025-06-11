module PostManager
  class List
    attr_reader :user, :branch_id

    def initialize(user, branch_id)
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
      if user.is_a?(Client)
        Post.includes(:product, :supermarket, :branch).all
      elsif user.is_a?(Supermarket)
        Post.includes(:product, :supermarket, :branch)
            .joins(:branch)
            .where(branches: { supermarket_id: user.id })
            .where(branches: { id: branch_id })
      else
        Post.none
      end
    end
  end
end
