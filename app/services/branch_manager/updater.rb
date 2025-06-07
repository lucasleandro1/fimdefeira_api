module BranchManager
  class Updater
    attr_reader :branch_id, :branch_params, :supermarket

    def initialize(branch_id, branch_params, supermarket)
      @branch_id = branch_id
      @branch_params = branch_params
      @supermarket = supermarket
    end

    def call
      response(scope)
    rescue ActiveRecord::RecordNotFound => e
      response_error("activerecord.errors.messages.branch_notfound: #{e.message}")
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(data)
      { success: true, message: I18n.t("activerecord.errors.messages.branch_update"), resources: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end

    def scope
      @branch = supermarket.branches.find_by(id: branch_id)

      if @branch.nil?
        raise ActiveRecord::RecordNotFound, "Branch not found for this supermarket"
      end

      unless @branch.update(branch_params)
        raise StandardError.new(@branch.errors.full_messages.to_sentence)
      end
      @branch
    end
  end
end
