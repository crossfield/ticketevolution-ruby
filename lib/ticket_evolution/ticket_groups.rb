module TicketEvolution
  class TicketGroups < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update

    def hold(params = nil)
      ensure_id
      request(:POST, "/hold", params, &method(:build_for_show))
    end

    def take(params = nil)
      ensure_id
      request(:POST, "/take", params, &method(:build_for_show))
    end

    def waste(params = nil)
      ensure_id
      request(:POST, "/waste", params, &method(:build_for_show))
    end

    def toggle_broadcast(params = nil)
      ensure_id
      request(:POST, "/broadcast", params, &method(:build_for_show))
    end

    def index_cart(ids = [])
      handler ||= method(:collection_handler)
      request(:GET, '/index_cart', ids, &handler)
    end
  end
end
