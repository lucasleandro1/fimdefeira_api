module TicketManager
  class Creator
    attr_reader :client, :ticket_params, :ticket_items_params

    def initialize(client, ticket_params, ticket_items_params)
      @client = client
      @ticket_params = ticket_params
      @ticket_items_params = ticket_items_params
    end

    def call
      ActiveRecord::Base.transaction do
        tickets = []

        grouped_by_branch = ticket_items_params.group_by do |item|
          Post.find(item[:post_id]).branch_id
        end

        grouped_by_branch.each do |branch_id, items|
          supermarket_id = Post.find(items.first[:post_id]).supermarket_id

          ticket = client.tickets.create!(
            ticket_params.merge(
              supermarket_id: supermarket_id,
              branch_id: branch_id,
              expires_at: 3.hours.from_now,
              status: :pendente
            )
          )

          items.each do |item|
            post = Post.find(item[:post_id])
            ti = ticket.ticket_items.create!(
              post: post,
              quantity: item[:quantity]
            )

            ti.update(subtotal_price: post.product.price * item[:quantity])
            post.product.decrement!(:stock_quantity, item[:quantity])
          end

          total_price = ticket.ticket_items.sum(&:subtotal_price)

          discount_percentage = client.current_discount
          discounted_price = total_price * (1 - discount_percentage.to_f / 100)

          ticket.update!(total_price: discounted_price)

          client.increment_cupons! if ticket.save!

          tickets << ticket
        end

        { success: true, resources: tickets }
      end
    rescue ActiveRecord::RecordInvalid => invalid
      { success: false, error_message: invalid.record.errors.full_messages.to_sentence }
    rescue StandardError => error
      { success: false, error_message: error.message }
    end
  end
end
