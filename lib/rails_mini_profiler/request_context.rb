# frozen_string_literal: true

module RailsMiniProfiler
  class RequestContext
    attr_reader :request, :profiler_context

    def initialize(profiler_context, request)
      @profiler_context = profiler_context
      @request = request
      @env = request.env
    end

    def user
      # If the user was explicitly set during the request use that, else fall back to ID provided by the user provider
      @user ||= (User.current_user || @profiler_context.configuration.user_provider.call(@env))
    end

    def authorized?
      @authorized ||= (@profiler_context.configuration.authorize.call(@env) && Authorization.authorized?)
    end
  end
end
