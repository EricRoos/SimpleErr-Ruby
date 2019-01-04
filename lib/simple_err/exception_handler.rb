module SimpleErr
  class ExceptionHandler
    class << self
      def handle(exception)
        self.new.handle(exception)
      end
    end

    def handle(exception)
      CreateRequest.new(create_request_payload(exception)).perform
    end

    protected

    def create_request_payload(exception)
      return nil unless exception
      return {
        exception_name: exception.class.to_s,
        message: exception.message,
        backtrace: exception.backtrace,
        client_app_id: SimpleErr.configuration.client_app_id
      }
    end
  end
end
