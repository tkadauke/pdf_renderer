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
  
  def test_should_render_pdf
    TestRenderer.template_class.any_instance.expects(:render)
    PdfRenderer::Latex.any_instance.expects(:generate_pdf)
    TestRenderer.render_something
  end
  
  def test_should_render_pdf_with_params
    TestRenderer.template_class.any_instance.expects(:render)
    PdfRenderer::Latex.any_instance.expects(:generate_pdf)
    TestRenderer.render_something_with_params('hello')
  end
  
  def test_should_save_pdf
    File.expects('open').with('/some/filename', 'wb')
    TestRenderer.save_something('/some/filename')
  end
  
  def test_should_build_correct_template_dir
    assert_equal "pdf_renderer/base_test/test_renderer", TestRenderer.new.template_dir
  end
  
  def test_should_render_arbitrary_file
    PdfRenderer::Base.template_class.any_instance.expects(:render)
    PdfRenderer::Latex.any_instance.expects(:generate_pdf)

    renderer = PdfRenderer::Base.new
    renderer.body :hello => 'world'
    renderer.render :file => 'some/path'
  end
end
