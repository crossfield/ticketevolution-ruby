require 'spec_helper'

shared_examples_for "a search endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#search" do
    context "with params" do
      let(:params) { {:page => 2, :per_page => 2, :q => "test"} }

      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, '/search', params)

        instance.search(params)
      end

      it "should set the @responsible to :search so that #request knows how to handle the response" do
        instance.should_receive(:request)
        instance.search(params)

        instance.instance_eval("@responsible").should == :search
      end
    end

    context "without params" do
      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, '/search', nil)

        instance.search
      end
    end
  end
end