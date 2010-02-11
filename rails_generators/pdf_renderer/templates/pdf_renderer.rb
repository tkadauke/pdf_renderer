class <%= class_name %>PdfRenderer < ActionFaxer::Base
<% for action in actions -%>
  def <%= action %>
    body :greeting => 'Hi,'
  end

<% end -%>
end
