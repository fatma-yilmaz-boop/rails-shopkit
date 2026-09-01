Gem::Specification.new do |s|
  s.name        = "rails-shopkit"
  s.version     = "1.4.0"
  s.authors     = ["Fatma Yılmaz"]
  s.email       = ["fatma@yilmaz.dev"]
  s.summary     = "Modular e-commerce engine for Ruby on Rails"
  s.description = "A modular, open-source e-commerce engine with multi-tenant support, payment integrations, and inventory management."
  s.license     = "MIT"
  s.homepage    = "https://github.com/fatma-yilmaz-boop/rails-shopkit"
  s.required_ruby_version = ">= 3.2"
  s.files = Dir["lib/**/*", "app/**/*", "config/**/*", "README.md", "LICENSE"]
  s.add_dependency "rails", ">= 7.1"
end
