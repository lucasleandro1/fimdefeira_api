module TicketManager
  class Finder
    attr_reader :user, :ticket_id

    def initialize(user, ticket_id)
      @user = user
      @ticket_id = ticket_id
    end

    def call
      ticket = Ticket.find_by(id: @ticket_id)

      return { success: false, error_message: "Ticket não encontrado" } unless ticket

      if @user.is_a?(Client)
        return { success: false, error_message: "Acesso negado" } unless ticket.client_id == @user.id
      elsif @user.is_a?(Supermarket)
        return { success: false, error_message: "Acesso negado" } unless @user.branches.exists?(id: ticket.branch_id)
      else
        return { success: false, error_message: "Usuário não autorizado" }
      end

      { success: true, resource: ticket }
    end
  end
end
