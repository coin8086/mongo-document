Gem::Specification.new do |s|
  s.name        = 'mongo-document'
  s.version     = '1.0.1'
  s.summary     = 'A slim Mongo document model'
  s.authors     = ['Robert Zhang']
  s.email       = 'louirobert@gmail.com'
  s.homepage    = 'https://github.com/coin8086/mongo-document'
  s.license     = 'MIT'
  s.files       = ['lib/mongo/document.rb', 'README.md']

  s.add_runtime_dependency 'mongo', '~> 2.2'
  s.add_runtime_dependency 'activesupport', '~> 4.0'
end

