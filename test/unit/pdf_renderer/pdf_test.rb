require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class PdfRenderer::PdfTest < Test::Unit::TestCase
  def setup
    @renderer = stub(:render! => 'output', :tex_out => 'source')
  end
  
  def test_should_render_pdf
    pdf = PdfRenderer::Pdf.new(@renderer)
    assert_equal 'output', pdf.render!
  end
  
  def test_should_save_pdf
    File.expects(:open).with('/some/filename', 'wb')
    pdf = PdfRenderer::Pdf.new(@renderer)
    pdf.save('/some/filename')
  end
end
