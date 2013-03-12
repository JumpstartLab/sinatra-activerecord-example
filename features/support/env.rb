$: << File.expand_path("../../lib", File.dirname(__FILE__))
require 'server'
require 'capybara/cucumber'
Capybara.app = Server
Capybara.default_driver = :selenium