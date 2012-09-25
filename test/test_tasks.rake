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

Rake::TestTask.new( 'test:modules' ) do |t|
  t.libs << ['test']
  t.test_files = FileList['test/modules/**/*_spec.rb']
  t.verbose = false
end

desc "Run all tests with a single task"
task 'test:all' => ['test:models', 'test:use_cases', 'test:modules']
