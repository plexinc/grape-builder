module Grape
  module Builder
    module Scope
      attr_accessor :partial
    end
    class Partial
      attr_reader :view_path, :scope

      def initialize(view_path, scope)
        @view_path = view_path
        @scope  = scope
      end

      def render(template, locals={})
        Grape::Builder::Renderer.new(view_path, template).
          render(scope, locals)
      end
    end
  end
end
