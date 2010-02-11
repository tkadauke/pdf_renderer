module PdfRenderer
  # This error is raised when no suitable LaTeX executable is found.
  class LatexProcessorNotFound < StandardError; end
  # This error is raised when there is a syntax error in the LaTeX input.
  class LatexError < StandardError; end
  # This error is raised when there is an illegal character in the LaTeX input.
  class InvalidCharacter < StandardError; end

  # This class wraps the LaTeX command invocation.
  class Latex
    attr_reader :options
    
    # Option redirection for shell output (default is '> /dev/null 2>&1' )
    cattr_accessor :shell_redirect
    self.shell_redirect = '> /dev/null 2>&1'
    # Temporary Directory
    cattr_accessor :tempdir
    self.tempdir = "#{File.expand_path(RAILS_ROOT)}/tmp"
    # tex command to run
    cattr_accessor :tex_command
    self.tex_command = "pdflatex"
    
    def initialize(options = {})
      @options = options
    end
    
    # Returns the rendered PDF as string for the given input string (LaTeX
    # source).
    def generate_pdf(input)
      create_debug_output(input) if options[:debug]
      check_for_tex_presence!
      create_pdf(input)
    end

  protected
    def processor
      self.class.tex_command
    end
    
    def run(command)
      %x{#{command}}
    end
    
    def create_debug_output(output)
      File.open("pdf_renderer_out.tex", "wb") {|f| f.puts output}
    rescue
    end
    
    def check_for_tex_presence!
      system_path = ENV["PATH"]

      # This is one big ugly platform dependent kludge, but it's necessary. 
      # See: http://lists.radiantcms.org/pipermail/radiant/2007-April/004473.html
      # In short, apache doesn't see environment variables like PATH.
      system_path = "/bin:/usr/bin:/usr/local/bin" if system_path.nil?

      # Check for the presence of the tex processor in the path.
      unless File.executable?(processor) or system_path.split(":").any?{|path| File.executable?(File.join(path, processor))}
        raise LatexProcessorNotFound
      end
    end
    
    def create_pdf(input)
      create_temp_dir("pdf_renderer", self.class.tempdir) do
        basename = "processed_pdf_renderer_file"
        texfile = File.open("#{basename}.tex", "wb")
        texfile.write(input)
        texfile.close

        tex_command = "#{processor} -interaction=nonstopmode #{texfile.path} #{self.class.shell_redirect}"
        tex_return = ''
        tex_return = run(tex_command)
        tex_return = run(tex_command) if options[:preprocess] # One can wonder if it matters if it's always run twice...

        if File.exists?("#{basename}.pdf")
          # For some reason, File.read doesn't work, hence the call using the block
          File.open("#{basename}.pdf",'rb') { |f| f.read }
        else
          if tex_return[/(Package inputenc Error: Unicode char .+)/,1]
            raise InvalidCharacter.new($1)
          end
          raise LatexError.new("Could not generate PDF:\n>>#{tex_return}<<\n\nPath:#{texfile.path}\n\n\nInput:#{input}")
        end
      end
    end

    @@temporary_dir_number = 0;

    # Creates a temp dir in location and performs the supplied code block
    def create_temp_dir(name, location)
      @@temporary_dir_number += 1
      pid = Process.pid # This doesn't work on some platforms, according to the docs. A better way to get it would be nice.
      random_number = Kernel.rand(1000000000).to_s # This is to avoid a possible symlink attack vulnerability in the creation of temporary files.
      complete_dir_name = "#{location}/#{name}.#{pid}.#{random_number}.#{@@temporary_dir_number}"

      yield_result = Object.new

      FileUtils.mkdir_p(complete_dir_name)
      Dir.chdir(complete_dir_name) do
        begin
          yield_result = yield
        ensure
          FileUtils.rmtree([complete_dir_name])
        end
      end

      yield_result
    end
  end
end
