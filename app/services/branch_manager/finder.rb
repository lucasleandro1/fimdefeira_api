module BranchManager
  class Finder
    attr_reader :supermarket, :branch_id

    def initialize(supermarket, branch_id)
      @supermarket = supermarket
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
      @supermarket.branches.find(branch_id)
    end
  end
end
