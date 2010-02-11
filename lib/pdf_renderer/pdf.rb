module PdfRenderer
  # Wrapper class that represents the PDF to be rendered. An instance of this
  # class is returned by a PdfRenderer, when an action is called without a
  # prefix (i.e. without <code>render_</code> or <code>save_</code>).
  class Pdf
    # Contains the LaTeX source for this PDF.
    attr_accessor :source
    # Contains the rendered PDF as string.
    attr_accessor :rendered
    
    def initialize(renderer)
      @renderer = renderer
    end
    
    # Renders the PDF.
    def render!
      @rendered = @renderer.render!
      @source = @renderer.tex_out
      @rendered
    end
    
    # Renders the PDF and saves it to the file system.
    def save(filename)
      File.open(filename, 'wb') { |file| file.print render! }
    end
  end
end
