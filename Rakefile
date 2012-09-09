#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

GatheringRails::Application.load_tasks

FileList['**/*.rake'].each do |task_file|
  load( File.expand_path( task_file ) )
end