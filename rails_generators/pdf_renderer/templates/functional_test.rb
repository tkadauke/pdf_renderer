require 'test_helper'
 
class <%= class_name %>PdfRendererTest < ActiveSupport::TestCase
<% for action in actions -%>
  test "<%= action %>" do
    pdf = <%= class_name %>PdfRenderer.render_<%= action %>
    assert pdf.source =~ /content/
  end

<% end -%>
<% if actions.blank? -%>
  # replace this with your real tests
  test "the truth" do
    assert true
  end
<% end -%>
end
