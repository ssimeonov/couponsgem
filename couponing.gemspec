# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "couponing"
  s.summary = "Insert Couponing summary."
  s.description = "Insert Couponing description."
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version = "0.0.5"
  
  s.add_runtime_dependency 'simple_form'
  
end