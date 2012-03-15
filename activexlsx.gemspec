Gem::Specification.new do |s|
  s.name          = "activexlsx"
  s.version       = "0.0.1"
  s.platform      = Gem::Platform::RUBY
  s.author        = "Viktor Kotseruba"
  s.summary       = "adds xlsx download option to activeadmin index pages"
  s.files         = `git ls-files`.split("\n")
  s.require_path  = "lib"
  
  s.add_dependency "axlsx",       "1.0.18"
  s.add_dependency "activeadmin", "0.4.2"
end
