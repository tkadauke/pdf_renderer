require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PdfRenderer::BaseTest < Test::Unit::TestCase
  class TestRenderer < PdfRenderer::Base
    def something
      body :var => 'hello'
    end
    
    def something_with_params(text)
      body :var => text
    end
  end
  
  def setup
    TestRenderer.view_paths = [File.dirname(__FILE__) + '/../fixtures']
  end

  def test_should_render_pdf
    assert TestRenderer.render_something =~ /^%PDF-\d\.\d/
  end
  
  def test_should_render_pdf_with_params
    assert TestRenderer.render_something_with_params('test') =~ /^%PDF-\d\.\d/
  end
  
  def test_should_evaluate_latex_erb_before_rendering
    pdf = TestRenderer.something_with_params('test string')
    pdf.render!
    assert pdf.source =~ /test string/
  end
end
