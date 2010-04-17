Gem::Specification.new do |s| 
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "pdf_renderer"
  s.version   =   "0.0.1"
  s.date      =   Date.today.strftime('%Y-%m-%d')
  s.author    =   "Thomas Kadauke"
  s.email     =   "entwicker@imedo.de"
  s.homepage  =   "http://www.imedo.de/"
  s.summary   =   "Framework for rendering PDFs using LaTeX"
  s.files     =   Dir.glob("lib/**/*") + Dir.glob("rails_generators/**/*")

  s.has_rdoc = true
  
  s.require_path = "lib"
end
