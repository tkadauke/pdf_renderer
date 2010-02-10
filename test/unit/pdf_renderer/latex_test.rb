require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PdfRenderer::LatexTest < Test::Unit::TestCase
  def test_should_render_pdf
    latex = PdfRenderer::Latex.new
    latex.expects(:check_for_tex_presence!)
    latex.expects(:create_pdf)
    latex.generate_pdf('something')
  end

  def test_should_write_debug_output
    latex = PdfRenderer::Latex.new(:debug => true)
    latex.stubs(:check_for_tex_presence!)
    latex.stubs(:create_pdf)
    
    File.expects(:open).with("pdf_renderer_out.tex", "wb")
    latex.generate_pdf('something')
  end
  
  def test_should_raise_exception_if_latex_not_present
    File.stubs(:executable?).returns(false)
    latex = PdfRenderer::Latex.new
    
    assert_raise PdfRenderer::LatexProcessorNotFound do
      latex.generate_pdf('something')
    end
  end
end
