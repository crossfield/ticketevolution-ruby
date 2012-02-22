require 'spec_helper'

describe TicketEvolution::Client do
  let(:klass) { TicketEvolution::Client }
  subject { TicketEvolution::Client }

  describe "when calling a nested endpoint method" do
    use_vcr_cassette "endpoints/clients", :record => :new_episodes

    let(:client) { TicketEvolution::Clients.new(:parent => connection).list.last }

    it "should pass the request to the appropriate endpoint and get back an appropriate response" do
      collection = client.addresses.list
      collection.should be_a TicketEvolution::Collection
      collection.total_entries.should == collection.size
      collection.first.should be_a TicketEvolution::Address
    end
  end

  it_behaves_like "a ticket_evolution model"

  context "#update_attributes" do
    let(:client) { connection.clients.create(:name => "foo") }
    let(:initial_client_id) { client.id }

    context "on success" do
      use_vcr_cassette "endpoints/clients/update_success", :record => :none, :match_requests_on => [:method, :uri, :body]
      before { client }

      it "updates the attributes of the instance" do
        client.update_attributes(:name => "bar")
        client.id.should == initial_client_id
        client.name.should == "bar"

        retrieved_client = connection.clients.find(initial_client_id)
        retrieved_client.name.should == "bar"
      end
    end

    context "on error" do
      use_vcr_cassette "endpoints/clients/update_fail", :record => :none, :match_requests_on => [:method, :uri, :body]
      before { client }

      it "doesn't update the attributes of the instance" do
        ret = client.update_attributes(:name => "")
        client.id.should == initial_client_id
        client.name.should == "foo"
        ret.should be_an_instance_of TicketEvolution::ApiError
        ret.code.should == 422

        retrieved_client = connection.clients.find(initial_client_id)
        retrieved_client.name.should == "foo"
      end
    end
  end
end
