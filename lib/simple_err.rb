# frozen_string_literal: true

require 'simple_err/version'
require 'simple_err/create_request'
require 'simple_err/exception_handler'

module SimpleErr
  class Configuration
    include ActiveModel::Model
    attr_accessor :client_app_id
  end
  @@configuration = Configuration.new

  # Your code goes here...
  def send(payload = {})
    CreateRequest.new(payload)
  end

  def exception_handler(exception); end

  def self.configure
    yield @@configuration
  end

  def self.configuration
    @@configuration
  end
end
