# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023-2024, by Samuel Williams.

require "protocol/rack/adapter"
require "protocol/http/reference"
require "sus/fixtures/async/http/server_context"
require "sus/fixtures/async/webdriver/session_context"

require "async/webdriver"

describe Sus::Fixtures::Async::WebDriver::SessionContext do
	include Sus::Fixtures::Async::HTTP::ServerContext
	include Sus::Fixtures::Async::WebDriver::SessionContext
	
	let(:app) do
		proc do |request|
			Protocol::HTTP::Response[200, [], [<<-HTML]]
				<html>
					<body>
						<form>
							<input type="text" name="foo" value="Hello World"/>
							<select name="bar">
								<option value="one">One</option>
								<option value="two">Two</option>
								<option value="three">Three</option>
							</select>
							<textarea name="baz">Hello World</textarea>
							<input type="hidden" name="qux" value="Hello World"/>
							<input type="submit" value="Submit"/>
						</form>
					</body>
				</html>
			HTML
		end
	end
	
	it "should be able to find elements" do
		navigate_to("/index.html")
		
		expect(session).to have_element(xpath: "//input[@name='foo']").and(
			have_properties(value: be == "Hello World")
		)
	end
	
	it "should be able to fill in forms" do
		navigate_to("/index.html")
		
		session.fill_in("foo", "Goodbye World")
		session.fill_in("bar", "Two")
		session.fill_in("baz", "Goodbye World")
		
		session.click_button("Submit")
	end
end
