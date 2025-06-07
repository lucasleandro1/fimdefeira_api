module BranchManager
  class Creator
    attr_reader :supermarket, :branch_params

    def initialize(supermarket, branch_params)
      @supermarket = supermarket
      @branch_params = branch_params
    end

    def call
      if branch_exists
        response_error(I18n.t("activerecord.errors.messages.branch_exists"))
      else
        response(create_branch)
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(data)
      { success: true, message: I18n.t("activerecord.messages.branch_created"), resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end

    def branch_exists
      supermarket.branches.exists?(
        address: branch_params[:address],
        telephone: branch_params[:telephone]
      )
    end

    def create_branch
      branch = supermarket.branches.new(branch_params)
      if branch.save
        branch
      else
        raise StandardError, branch.errors.full_messages.to_sentence
      end
    end
  end
end
