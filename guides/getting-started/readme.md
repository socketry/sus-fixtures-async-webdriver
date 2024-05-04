# Getting Started

This guide is designed to help you get started with the `sus-fixtures-async-webdriver` gem.

## Installation

Add the gem to your project:

``` bash
$ bundle add sus-fixtures-async-webdriver
```

## Usage

Simply add the appropriate fixtures to your integration tests:

```ruby
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
end
```

See `examples/rack` for a full example.