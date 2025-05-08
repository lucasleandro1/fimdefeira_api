module PostManager
  class Finder
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
      { success: true, resources: data }
    end

    def response_error(error)
      { success: false, error_message: error.message }
    end

    def scope
      Post.find(post_id)
    end
  end
end
