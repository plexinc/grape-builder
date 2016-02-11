module Grape
  module Builder
    class Renderer
      def initialize(view_path, template)
        @view_path, @template = view_path, template
      end

      def render(scope, locals = {})
        unless view_path
          raise "Use Rack::Config to set 'api.tilt.root' in config.ru"
        end

        scope.extend Grape::Builder::Scope
        scope.partial = Grape::Builder::Partial.new(view_path, scope)

        engine = ::Tilt.new file, nil, view_path: view_path
        engine.render scope, locals
      end

      private

      attr_reader :view_path, :template

      def file
        File.join view_path, template_with_extension
      end

      def template_with_extension
        template[/\.builder$/] ? template : "#{template}.builder"
      end
    end
  end
end
