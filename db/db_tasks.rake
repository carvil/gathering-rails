namespace :app do

  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "\nSorry but this task should not be executed against the production environment"
    end
  end

  desc "Reset"
  task :reset => [:ensure_development_environment, "db:migrate:reset", "db:seed", "app:populate_dev"]

  desc "Load the development environment"
  task :populate_dev => [:ensure_development_environment, :environment] do
    require 'miniskirt'
    require_relative '../test/factories/factories'

    user_1 = User.find_or_create_by_email(:email => "user1@gathering.com", :first_name => "user", :last_name => "1", :display_name => "user 1", :password=>"passmeon", :password_confirmation => "passmeon")
    user_2 = User.find_or_create_by_email(:email => "user2@gathering.com", :first_name => "user", :last_name => "2",  :display_name => "user 2", :password=>"passmeon", :password_confirmation => "passmeon")
    user_1.confirm! && user_2.confirm!

    gu1 = Factory.create(:owner, :user => user_1)
    gu2 = Factory.create(:contributor, :user => user_2, :gathering => gu1.gathering)
    gu3 = Factory.create(:owner, :user => user_2)
    gu4 = Factory.create(:reader, :user => user_1)
    gu5 = Factory.create(:owner, :user => user_1)

    e1 = Factory.create(:event, :gathering => gu1.gathering)
    e2 = Factory.create(:event, :gathering => gu1.gathering)
    e3 = Factory.create(:event, :gathering => gu1.gathering)
    e4 = Factory.create(:event, :gathering => gu3.gathering)
    e5 = Factory.create(:event, :gathering => gu3.gathering)
    e6 = Factory.create(:event, :gathering => gu4.gathering)
    e6 = Factory.create(:event, :gathering => gu5.gathering)
    e6 = Factory.create(:event, :gathering => gu5.gathering)
    e6 = Factory.create(:event, :gathering => gu5.gathering)
    e6 = Factory.create(:event, :gathering => gu5.gathering)
    e6 = Factory.create(:event, :gathering => gu5.gathering)
  end

end
