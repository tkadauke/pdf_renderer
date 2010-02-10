require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PdfRenderer::LatexTest < Test::Unit::TestCase
  def test_should_render_pdf
    latex = PdfRenderer::Latex.new
    result = latex.generate_pdf('\documentclass[a4paper]{report} \title{Hello World in LaTeX } \begin{document} Hello World \end{document}')
    assert result =~ /%PDF-\d\.\d/
  end
  
  def test_should_raise_exception_if_there_are_latex_errors
    latex = PdfRenderer::Latex.new
    assert_raise PdfRenderer::LatexError do
      latex.generate_pdf('\documentclass[a4paper]{report} \title{Hello World in LaTeX } \begin{document}')
    end
  end
end
