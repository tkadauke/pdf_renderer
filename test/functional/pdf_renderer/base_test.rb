require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

module FirstTestHelper
  def first
  end
end

module SecondTestHelper
  def second
  end
end

module ThirdTestHelper
  def third
  end
end

class PdfRenderer::BaseTest < Test::Unit::TestCase
  class TestRenderer < PdfRenderer::Base
    def something
      body :var => 'hello'
    end
    
    def something_with_params(text)
      body :var => text
    end
  end
  
  class RendererWithHelper < PdfRenderer::Base
    helper :first_test, 'second_test', ThirdTestHelper
    
    def something
    end
  end
  
  def setup
    TestRenderer.view_paths = [File.dirname(__FILE__) + '/../fixtures']
    RendererWithHelper.view_paths = [File.dirname(__FILE__) + '/../fixtures']
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
  
  def test_should_include_helper_modules
    assert_nothing_raised do
      assert RendererWithHelper.render_something =~ /^%PDF-\d\.\d/
    end
  end
end
