class PdfRendererGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions "#{class_name}PdfRenderer", "#{class_name}PdfRendererTest"

      # Renderer, view, and test directories.
      m.directory File.join('app/pdf_renderers', class_path)
      m.directory File.join('app/views', "#{file_path}_pdf_renderer")
      m.directory File.join('test/functional', class_path)

      # Renderer class and functional test.
      m.template "pdf_renderer.rb",    File.join('app/pdf_renderers', class_path, "#{file_name}_pdf_renderer.rb")
      m.template "functional_test.rb", File.join('test/functional', class_path, "#{file_name}_pdf_renderer_test.rb")

      # View template for each action.
      actions.each do |action|
        relative_path = File.join("#{file_path}_pdf_renderer", action)
        view_path     = File.join('app/views', "#{relative_path}.pdf.erb")

        m.template "view.erb", view_path,
                   :assigns => { :action => action, :path => view_path }
      end
    end
  end
end
