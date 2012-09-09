require 'rake/testtask'

Rake::TestTask.new( 'test:unit:models' ) do |t|
  t.libs << ['test']
  t.test_files = FileList['test/unit/models/**/*_spec.rb']
  t.verbose = false
end