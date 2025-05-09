module Branchanager
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
      { success: true, message: "activerecord.errors.messages.branch_delete", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end

    def scope
      @branch = Branch.find(branch_id)
      unless @branch.destroy
        raise StandardError.new(product.errors.full_messages.to_sentence)
      end
    end
  end
end
