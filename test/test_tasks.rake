require 'rake/testtask'

Rake::TestTask.new( 'test:models' ) do |t|
  t.libs << ['test']
  t.test_files = FileList['test/models/**/*_spec.rb']
  t.verbose = false
end

Rake::TestTask.new( 'test:use_cases' ) do |t|
  t.libs << ['test']
  t.test_files = FileList['test/use_cases/**/*_spec.rb']
  t.verbose = false
end