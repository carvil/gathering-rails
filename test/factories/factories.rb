
## Gathering Factory ##
Factory.define :gathering, :class => Gathering do |g|
  g.name          "gathering %d"
  g.description   "%{name} description"
  g.location      "somewhere out there %d"
end

## Event Factory ##
Factory.define :event, :class => Event do |e|
  e.title           "event %d"
  e.description     "%{title} description"
  e.scheduled_date  "#{DateTime.now}"
  e.gathering       { Factory :gathering }
  e.location        { |ev| "#{ev.gathering.location} event" }
end

Factory.define :user, :class => User do |u|
  u.first_name "Test %d"
  u.last_name "User %d"
  u.display_name "%{first_name}"
  u.email "%{first_name}@gathering_rails.test"
  u.password u.password_confirmation('please')
  u.confirmed_at { Time.new }
end
