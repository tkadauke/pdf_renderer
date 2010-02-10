module PdfRenderer
  class Pdf
    attr_accessor :source, :rendered
    
    def initialize(renderer)
      @renderer = renderer
    end
    
    def render!
      @rendered = @renderer.render!
      @source = @renderer.tex_out
      @rendered
    end
    
    def save(filename)
      File.open(filename, 'wb') { |file| file.print render! }
    end
  end
end
