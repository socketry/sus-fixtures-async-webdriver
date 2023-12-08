require 'sus/fixtures/async/http/server_context'
require 'sus/fixtures/async/webdriver/session_context'

require 'protocol/rack/adapter'
require 'rack/builder'

describe "my website" do
	include Sus::Fixtures::Async::HTTP::ServerContext
	include Sus::Fixtures::Async::WebDriver::SessionContext
	
	def middleware
		Protocol::Rack::Adapter.new(app)
	end
	
	def app
		Rack::Builder.load_file(File.expand_path('../config.ru', __dir__))
	end
	
	it "has a title" do
		navigate_to('/')
		
		expect(session.document_title).to be == "Example"
	end
	
	it "has a heading" do
		navigate_to('/')
		
		expect(session).to have_element(tag_name: "h1")
	end
	
	it "has a paragraph" do
		navigate_to('/')
		
		expect(session).to have_element(tag_name: "p")
	end
end
