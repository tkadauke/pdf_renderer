require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class PdfRenderer::Helpers::LatexHelperTest < Test::Unit::TestCase
  include PdfRenderer::Helpers::LatexHelper
  
  def test_should_escape_brackets
    assert_equal '\{\}', latex_escape("{}")
  end
  
  def test_should_escape_special_characters
    assert_equal '\_\$\&\%\#', latex_escape("_$&%#")
  end
  
  def test_should_escape_backslashes
    assert_equal '\textbackslash{}', latex_escape("\\")
  end
  
  def test_should_escape_hat
    assert_equal '\textasciicircum{}', latex_escape("^")
  end
  
  def test_should_escape_tilde
    assert_equal '\textasciitilde{}', latex_escape("~")
  end
  
  def test_should_build_symmetric_quotes
    assert_equal %{hello "`world"' whats up}, latex_escape('hello "world" whats up')
  end
end
