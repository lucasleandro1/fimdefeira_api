module TicketManager
  class Creator
    attr_reader :client, :ticket_params, :ticket_items_params

    def initialize(client, ticket_params, ticket_items_params)
      @client = client
      @ticket_params = ticket_params
      @ticket_items_params = ticket_items_params
    end

    def call
      if ticket_exists?
        response_error(message: "O ticket já existe para este produto")
      else
        ActiveRecord::Base.transaction do
          ticket = create_ticket
          create_ticket_items(ticket)
          response(ticket)
        end
      end
    rescue StandardError => error
      response_error(error.message)
    end

    private

    def response(data)
      { success: true, message: "Ticket criado com sucesso", resource: data }
    end

    def response_error(error)
      { success: false, error_message: error }
    end

    def ticket_exists?
      # Verifica se já existe um ticket com o mesmo produto e cliente
      client.tickets.joins(:ticket_items).exists?(ticket_items: { product_id: ticket_params[:product_id] })
    end

    def create_ticket
      ticket = client.tickets.new(ticket_params)

      if ticket.save
        ticket
      else
        raise StandardError, ticket.errors.full_messages.to_sentence
      end
    end

    def create_ticket_items(ticket)
      ticket_items = ticket_items_params.map do |item_param|
        ticket.ticket_items.create!(product_id: item_param[:product_id], quantity: item_param[:quantity])
      end
    end
  end
end
