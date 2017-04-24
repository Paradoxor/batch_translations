$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "batch_translations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "batch_translations"
  s.version     = BatchTranslations::VERSION
  s.authors     = ["Jonathon Padfield"]
  s.email       = ["jonathon.padfield@gmail.com"]
  s.homepage    = "https://github.com/trammel/batch_translations"
  s.summary     = "Render globalized fields on a per-locale basis for mass editing."
  s.description = "Helper that renders globalize_translations fields on a per-locale basis, so you can use them separately in the same form and still saving them all at once in the same request."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0.1"
end
