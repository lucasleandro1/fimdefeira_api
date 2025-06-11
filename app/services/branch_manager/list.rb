module BranchManager
  class List
    attr_reader :supermarket, :branch

    def initialize(supermarket, branch)
      @supermarket = supermarket
      @branches = branch
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
      @supermarket.branches
    end
  end
end
