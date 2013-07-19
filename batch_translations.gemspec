Gem::Specification.new do |s|
  s.name = "batch_translations"
  s.version = "0.1.4"
  s.date = "2013-07-19"
  s.summary = "allow saving multiple globalize2 translations in the same request"
  s.email = "sebcioz@gmail.com"
  s.homepage = "https://github.com/sebcioz/batch_translations"
  s.description = "Helper that renders globalize_translations fields on a per-locale basis, so you can use them separately in the same form and still saving them all at once in the same request."
  s.require_path = "lib"
  s.has_rdoc = false
  s.authors = ['Szymon Fiedler']
  s.files = ["batch_translations.gemspec", 'lib/batch_translations.rb'] +
    Dir.glob("lib/**/*")
		
	s.add_dependency 'activerecord', '>= 4.0.0'
end
