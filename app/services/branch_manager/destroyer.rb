module BranchManager
  class Destroyer
    attr_reader :branch_id

    def initialize(branch_id)
      @branch_id = branch_id
    end

    def call
      response(scope)
    rescue StandardError => error
      response_error(error)
    end

    private

    def response(data)
      { success: true, message: I18n.t("activerecord.errors.messages.branch_delete"), resource: data }
    end

    def response_error(error)
      { success: false, error_message: error.message }
    end

    def scope
      @branch = Branch.find(branch_id)
      unless @branch.destroy
        raise StandardError.new(@branch.errors.full_messages.to_sentence)
      end
      @branch
    end
  end
end
