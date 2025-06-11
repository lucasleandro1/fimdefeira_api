module TicketManager
  class List
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      if user.is_a?(Client)
        tickets = user.tickets.includes(:branch, ticket_items: { post: :product })
      elsif user.is_a?(Supermarket)
        branch_id = user.branches.pluck(:id)
        tickets = Ticket.where(branch_id: branch_id, status: :pendente)
                        .includes(:branch, ticket_items: { post: :product })
      else
        return { success: false, error_message: "Usuário não autorizado" }
      end

      { success: true, resources: tickets }
    end
  end
end
