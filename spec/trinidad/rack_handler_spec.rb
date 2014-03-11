require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe 'Rack::Handler::Trinidad' do

  it "is not loaded by default" do
    require 'trinidad'
    defined?(Rack::Handler::Trinidad).should be nil
  end

  describe 'Rack::Handler::Trinidad' do

    before(:all) { require "rack/handler/trinidad" }

    it "registers the trinidad handler" do
      Rack::Handler.get(:trinidad).should == Rack::Handler::Trinidad
    end

    it "turns the threads option into jruby min/max runtimes" do
      opts = Rack::Handler::Trinidad.parse_options({:threads => '2:3'})
      opts[:jruby_min_runtimes].should == 2
      opts[:jruby_max_runtimes].should == 3
    end

    it "uses localhost:3000 as default host:port" do
      opts = Rack::Handler::Trinidad.parse_options
      opts[:address].should == 'localhost'
      opts[:port].should == 3000
    end

    it "accepts host:port or address:port as options" do
      opts = Rack::Handler::Trinidad.parse_options({:host => 'foo', :port => 4000})
      opts[:address].should == 'foo'
      opts[:port].should == 4000

      opts = Rack::Handler::Trinidad.parse_options({:address => 'bar', :port => 5000})
      opts[:address].should == 'bar'
      opts[:port].should == 5000
    end

    it "creates a servlet for the app" do
      app = mock("app")
      servlet = Rack::Handler::Trinidad.create_servlet(app)
      servlet.context.server_info.should == 'Trinidad'
      servlet.dispatcher.should_not be nil
    end

    it "starts a trinidad server" do
      expect(Trinidad::Server).to receive(:new).and_return server = double("server")
      expect(server).to receive(:start)

      Rack::Handler::Trinidad.run app = double("app")
    end

    it "yields when a block is given to run" do
      expect(Trinidad::Server).to receive(:new).and_return server = double("server")
      expect(server).to receive(:start)

      app = double("app")

      yielded = false
      Rack::Handler::Trinidad.run(app) do |server|
        server.should be(server)
        yielded = true
      end
      yielded.should == true
    end

  end

end
