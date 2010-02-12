module PdfRenderer
  # Base class for rendering PDFs. PDFs are rendered in two passes. The first
  # pass evaluates an LaTeX ERB template. In the second pass the evaluated
  # output is piped through pdflatex. The resulting PDF is returned as a string.
  #
  # === Usage
  #
  # The usage is very similar to ActionMailer. Example:
  #
  #   class BillPdfRenderer < PdfRenderer::Base
  #     def bill(model)
  #       body :variable => model
  #     end
  #   end
  #
  # Render the PDF using
  #
  #   pdf_as_string = BillPdfRenderer.render_bill(model)
  #
  # The default template path is
  # <code>underscored_class_name/action_name.pdf.erb</code> and is looked for in
  # all specified view_paths.
  #
  # === Saving PDFs
  #
  # You can also use PdfRenderer::Base to generate and save PDFs to the file
  # system. Instead of calling <code>render_</code>
  #
  # === Helpers
  #
  # To use view helpers, declare them in class scope. You can declare them as
  # symbols, strings or constants, camelized or underscored. Omit the "Helper"
  # suffix when using strings or symbols.
  #
  # The LatexHelper included in the PdfRenderer gem is automatically added to
  # the ActionView instance. This helper contains methods for escaping strings
  # to LaTeX.
  #
  # === Options
  #
  # Inside of render actions, there are a couple of options you can use:
  #
  # preprocess:: Run pdflatex twice for assigning page numbers etc.
  # debug::      Save the rendered tex source to the file system for debugging.
  class Base
    include ActionMailer::AdvAttrAccessor
    include PdfRenderer::Helpers
    
    adv_attr_accessor :body, :template_name, :preprocess, :debug
    
    # Contains the input for LaTeX
    attr_reader :tex_out
    
    # Paths where views are looked for in.
    class_inheritable_array :view_paths
    
    # Sets default options
    #
    # preprocess:: <code>false</code>
    # debug::      <code>false</code>
    def initialize
      preprocess false
      debug false
    end
    
    # Depending on the method pattern, does one of three things:
    #
    # * If the method name starts with <code>render_</code>, the action is
    #   called on a new instance of the renderer and the rendered PDF is
    #   returned as a string.
    # * If the method starts with <code>save_</code>, the action is called,
    #   the PDF is generated and saved to the path given in the first method
    #   argument.
    # * Otherwise, the action is called on a new instance of the renderer and a
    #   Pdf object is returned.
    def self.method_missing(method, *params)
      if method.to_s =~ /^render_(.*)$/
        pdf = send($1, *params)
        pdf.render!
      elsif method.to_s =~ /^save_(.*)$/
        file_name = params.shift
        pdf = send($1, *params)
        pdf.save(file_name)
      elsif instance_methods.include?(method.to_s)
        renderer_instance = new
        renderer_instance.template_name = method
        renderer_instance.send(renderer_instance.template_name, *params)
        Pdf.new(renderer_instance)
      else
        super
      end
    end
    
    # The root for view files.
    def self.template_root
      "#{RAILS_ROOT}/app/views"
    end
    
    # The directory in which templates are stored by default for this renderer.
    def template_dir
      self.class.name.underscore
    end
    
    # The complete path to the LaTeX ERB template.
    def template_path
      "#{template_dir}/#{template_name}"
    end
    
    # Delegates the render call to ActionView and runs the resulting LaTeX code
    # through pdflatex.
    def render(options)
      @tex_out = template_instance.render options
      Latex.new(:preprocess => preprocess, :debug => debug).generate_pdf(tex_out)
    end
    
    # Renders the default template.
    def render!
      render :file => template_path
    end
    
  protected
    def self.template_class
      @template_class ||= returning Class.new(ActionView::Base) do |view_class|
        view_class.send(:include, ApplicationController.master_helper_module) if Object.const_defined?(:ApplicationController)
        view_class.send(:include, PdfRenderer::Helpers::LatexHelper)
        view_class.send(:include, self.master_helper_module)
      end
    end
    
    def template_instance
      returning self.class.template_class.new(self.class.template_root, body || {}, self) do |view|
        view.template_format = :pdf
        view.view_paths = ActionView::Base.process_view_paths(self.view_paths)
      end
    end
  end
end
