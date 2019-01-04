require 'active_model'
require 'faraday'

module SimpleErr
  class CreateRequest
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON
    attr_accessor :exception_name, :message, :backtrace, :client_app_id

    validates_presence_of :message, :exception_name

    def perform
      return false unless valid?
      conn = Faraday.new(:url => 'http://localhost:3000')
      response = conn.post "/client_apps/#{client_app_id}/client_app_errors", to_param
      response.status == 201
    end

    def to_param
      {
        client_app_error: as_json(except: :client_app_id).symbolize_keys
      }
    end

    def attributes # needed for AM::Serializers
      instance_values
    end
  end
end
