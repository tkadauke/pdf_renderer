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

class PdfRenderer::HelpersTest < Test::Unit::TestCase
  class RendererWithHelper < PdfRenderer::Base
    helper :first_test, 'second_test', ThirdTestHelper
    
    def something
    end
  end
  
  def setup
    RendererWithHelper.view_paths = [File.dirname(__FILE__) + '/../fixtures']
  end

  def test_should_include_helper_modules
    assert_nothing_raised do
      assert RendererWithHelper.render_something =~ /^%PDF-\d\.\d/
    end
  end
end
