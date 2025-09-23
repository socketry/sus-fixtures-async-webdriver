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

## Automatic Debugging

When tests fail, the `SessionContext` automatically captures debugging information to help you understand what went wrong:

- **HTML Source**: The current page DOM structure is saved to a timestamped `.html` file
- **Screenshot**: A visual screenshot of the page is saved to a timestamped `.png` file

Debug files are automatically named with the test class and timestamp (e.g., `debug-MyTestClass-20250923-143022.html`) and saved to the current working directory. When a test fails, you'll see output like:

```
🐛 Test failed, debug files captured: 📄 HTML: debug-MyTestClass-20250923-143022.html 📸 Screenshot: debug-MyTestClass-20250923-143022.png ❌ Error: NoSuchElementError: Element not found
```

This debugging information is captured automatically without any additional setup - just include the `SessionContext` fixture and it will handle debug capture on test failures.
