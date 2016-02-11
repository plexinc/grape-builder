module Grape
  module Formatter
    class Builder
      attr_reader :env, :endpoint, :object

      def self.call(object, env)
        new(object, env).call
      end

      def initialize(object, env)
        @object, @env = object, env
        @endpoint     = env['api.endpoint']
      end

      def call
        return Grape::Formatter::Xml.call(object, env) unless template?

        Grape::Builder::Renderer.new(env['api.tilt.root'], template).
          render(endpoint, locals)
      end

      private

      def locals
        env['api.tilt.locals'] || {}
      end

      def template
        env['api.tilt.template'] ||
        endpoint.options.fetch(:route_options, {})[:builder]
      end

      def template?
        !!template
      end
    end
  end
end
