require 'spec_helper'

describe TicketEvolution::Account do
  subject { TicketEvolution::Account }

  it_behaves_like "a ticket_evolution model"
  it_behaves_like "a parental model"
end
