module PdfRenderer
  class Base
    include ActionMailer::AdvAttrAccessor
    
    adv_attr_accessor :body, :template_name, :preprocess, :debug
    
    attr_reader :tex_out
    
    class_inheritable_array :view_paths
    
    def initialize
      preprocess false
      debug false
    end
    
    def self.method_missing(method, *params)
      if method.to_s =~ /^render_(.*)$/
        pdf = send($1, *params)
        pdf.render!
      elsif method.to_s =~ /^save_(.*)$/
        file_name = params.shift
        pdf = send($1, *params)
        pdf.save(file_name)
      else
        renderer_instance = new
        renderer_instance.template_name = method
        renderer_instance.send(renderer_instance.template_name, *params)
        Pdf.new(renderer_instance)
      end
    end
    
    def self.template_root
      "#{RAILS_ROOT}/app/views"
    end
    
    def template_dir
      self.class.name.underscore
    end
    
    def template_path
      "#{template_dir}/#{template_name}"
    end
    
    def render(options)
      @tex_out = template_instance.render options
      Latex.new(:preprocess => preprocess, :debug => debug).generate_pdf(tex_out)
    end
    
    def render!
      render :file => template_path
    end
  
  protected
    def self.template_class
      @template_class ||= returning Class.new(ActionView::Base) do |view_class|
        view_class.send(:include, ApplicationController.master_helper_module) if Object.const_defined?(:ApplicationController)
        view_class.send(:include, PdfRenderer::Helpers::LatexHelper)
      end
    end
    
    def template_instance
      returning self.class.template_class.new(self.class.template_root, body, self) do |view|
        view.template_format = :pdf
        view.view_paths = ActionView::Base.process_view_paths(self.view_paths)
      end
    end
  end
end
