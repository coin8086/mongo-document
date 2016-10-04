Gem::Specification.new do |s|
  s.name        = 'mongo-document'
  s.version     = '1.0.0'
  s.summary     = 'A slim Mongo document model'
  s.authors     = ['Robert Zhang']
  s.email       = 'louirobert@gmail.com'
  s.homepage    = 'https://github.com/coin8086/mongo-document'
  s.license     = 'MIT'
  s.files       = ['lib/mongo/document.rb']

  s.add_runtime_dependency 'mongo', '~> 2.2'
end

