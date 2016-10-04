
desc "Run tests"
task :default do
  [
    { :file => "document_test.rb", :env => { 'RACK_ENV' => 'foo', 'MD_NO_AUTO_CONFIG' => '1' }},
    { :file => "document_config_test.rb", :env => { 'RACK_ENV' => 'test2' }},
  ].each do |test|
    puts "--------------------------------------"
    puts "#{test[:file]}:"
    system(
      test[:env],
      RbConfig.ruby, File.join('test', 'mongo', test[:file]),
      :chdir => Dir.pwd,
    )
  end
end

