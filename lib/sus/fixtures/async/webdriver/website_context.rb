require 'async/webdriver'
require 'async/webdriver/bridge/pool'

module Sus
	module Fixtures
		module Async
			module WebDriver
				module WebsiteContext
					GUARD = Thread::Mutex.new
					
					def self.pool
						return @pool if @pool
						
						GUARD.synchronize do
							@pool ||= begin
								at_exit do
									@pool&.close
								end
								
								::Async::WebDriver::Bridge::Pool.start(
									::Async::WebDriver::Bridge::Chrome.new
								)
							end
						end
					end
					
					def session
						@session ||= WebsiteContext.pool.session
					end
					
					def before
						super
						
						@session = nil
					end
					
					def after
						if @session
							WebsiteContext.pool.reuse(@session)
							@session = nil
						end
						
						super
					end
					
					def navigate_to(path)
						session.navigate_to(URI.join(bound_url, path))
					end
					
					def find_element(...)
						session.find_element(::Async::WebDriver::Locator.wrap(...))
					end
					
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
