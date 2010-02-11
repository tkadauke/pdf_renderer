module PdfRenderer
  module Helpers
    def self.included(base)
      base.class_inheritable_array :helpers
      base.extend ClassMethods
    end
    
    module ClassMethods
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
