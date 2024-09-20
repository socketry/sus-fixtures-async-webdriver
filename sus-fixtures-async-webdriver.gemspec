# frozen_string_literal: true

require_relative "lib/sus/fixtures/async/webdriver/version"

Gem::Specification.new do |spec|
	spec.name = "sus-fixtures-async-webdriver"
	spec.version = Sus::Fixtures::Async::WebDriver::VERSION
	
	spec.summary = "A set of sus fixtures for writing integration tests."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ["release.cert"]
	spec.signing_key = File.expand_path("~/.gem/release.pem")
	
	spec.homepage = "https://github.com/socketry/sus-fixtures-async-webdriver"
	
	spec.metadata = {
		"documentation_uri" => "https://socketry.github.io/sus-fixtures-async-webdriver/",
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
		"source_code_uri" => "https://github.com/socketry/sus-fixtures-async-webdriver.git",
	}
	
	spec.files = Dir.glob(["{lib}/**/*", "*.md"], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "async-webdriver", "~> 0.3"
end
