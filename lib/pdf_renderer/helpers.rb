module PdfRenderer
  # Contains functionality for using helper modules in the views when rendering
  # LaTeX ERB files.
  module Helpers
    def self.included(base)
      base.class_inheritable_array :helpers
      base.extend ClassMethods
    end
    
    module ClassMethods
      # Class-level method that declares <code>helpers</code> as helpers for
      # inclusion in the view. Specify the helpers as <code>:symbol</code>,
      # <code>'string'</code>, or <code>ConstantName</code>.
      def helper(*helpers)
        write_inheritable_array :helpers, helpers
      end

    protected
      def master_helper_module
        @master_helper_module ||= returning(Module.new) do |mod|
          (helpers || []).each do |helper|
            case helper
            when Module
              mod.send(:include, helper)
            when String, Symbol
              mod.send(:include, "#{helper.to_s}_helper".camelize.constantize)
            end
          end
        end
      end
    end
  end
end
