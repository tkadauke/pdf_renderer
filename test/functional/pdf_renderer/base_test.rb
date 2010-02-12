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
    FileUtils.mkdir_p File.dirname(__FILE__) + '/../../tmp/'
    TestRenderer.view_paths = [File.dirname(__FILE__) + '/../fixtures']
  end
  
  def teardown
    FileUtils.rm_f File.dirname(__FILE__) + '/../../tmp/test.pdf'
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
  
  def test_should_save_pdf_to_filesystem
    TestRenderer.save_something_with_params(File.dirname(__FILE__) + '/../../tmp/test.pdf', 'test string')
    assert File.exists?(File.dirname(__FILE__) + '/../../tmp/test.pdf')
  end
end
