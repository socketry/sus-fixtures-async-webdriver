# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023-2024, by Samuel Williams.

require "async/webdriver"
require "async/webdriver/bridge/pool"

module Sus
	module Fixtures
		module Async
			module WebDriver
				# The session context provides a way to manage the lifecycle of a WebDriver session.
				module SessionContext
					GUARD = Thread::Mutex.new
					
					def self.pool
						return @pool if @pool
						
						GUARD.synchronize do
							@pool ||= begin
								::Async::WebDriver::Bridge::Pool.new(
									::Async::WebDriver::Bridge.default
								)
							end
						end
					end
					
					def make_session
						SessionContext.pool.session.tap do |session|
							# 1 second timeout for implicit waits.
							session.implicit_wait_timeout = 1000
						end
					end
					
					# The current session, that represents the browser window.
					def session
						@session ||= make_session
					end
					
					def before
						super
						
						@session = nil
					end
					
					def after(error = nil)
						if @session
							SessionContext.pool.reuse(@session)
							@session = nil
						end
						
						super
					end
					
					# Navigate to a specific path within the website.
					# @parameter path [String] The path to navigate to.
					def navigate_to(path)
						session.navigate_to(URI.join(bound_url, path))
					end
					
					# Find an element within the current session.
					# @parameter locator [Hash] The locator to use to find the element.
					def find_element(...)
						session.find_element(::Async::WebDriver::Locator.wrap(...))
					end
					
					# Find all elements matching the given locator.
					# @parameter locator [Hash] The locator to use to find the elements.
					def find_elements(...)
						session.find_elements(::Async::WebDriver::Locator.wrap(...))
					end
					
					class HaveElement
						def initialize(locator)
							@locator = locator
							@predicate = nil
						end
						
						def and(predicate)
							@predicate = predicate
							self
						end
						
						def print(output)
							output.write("have element ", :variable, @locator.inspect, :reset)
							
							if @predicate
								output.write(" and ", @predicate)
							end
						end
						
						def call(assertions, subject)
							assertions.nested(self) do |assertions|
								element = subject.find_element(@locator)
								assertions.assert(element, "have element")
								
								@predicate&.call(assertions, element)
							rescue ::Async::WebDriver::NoSuchElementError
								assertions.assert(nil, "have element")
							end
						end
					end
					
					# Check if the current session has an element matching the given locator.
					def have_element(...)
						HaveElement.new(::Async::WebDriver::Locator.wrap(...))
					end
					
					class HaveProperty
						def initialize(name, value)
							@name = name
							@value = value
						end
						
						def print(output)
							output.write("have property ", :variable, @name.inspect, :reset, " ", :variable, @value.inspect, :reset)
						end
						
						def call(assertions, subject)
							assertions.assert(subject.property(@name), "have property")
						end
					end
					
					# Check if an element has properties matching the given key-value pairs.
					def have_properties(**properties)
						predicates = properties.map do |key, value|
							HaveProperty.new(key, value)
						end
						
						Sus::Have::All.new(predicates)
					end
				end
			end
		end
	end
end
