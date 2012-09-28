
## Gathering Factory ##
Factory.define :gathering, :class => Gathering do |g|
  g.name          "gathering %d"
  g.description   "%{name} description"
  g.scheduled_date { Time.new }
  g.location      "somewhere out there %d"
end

## Event Factory ##
Factory.define :event, :class => Event do |e|
  e.title           "event %d"
  e.description     "%{title} description"
  e.scheduled_date  "#{DateTime.now}"
  e.gathering       { Factory.create(:gathering) }
  e.location        { |ev| "#{ev.gathering.location} event" }
end

Factory.define :user, :class => User do |u|
  u.first_name "Test%d"
  u.last_name "User%d"
  u.display_name "%{first_name}"
  u.email "%{first_name}@gathering_rails.test"
  u.password u.password_confirmation('please')
  u.confirmed_at { Time.new }
end

#TODO: potentially revise this for more sustainability; hard-coding the role values might not be the best way as it may hide testing failures
Factory.define :reader, :class => GatheringUser do |gu|
  gu.user { Factory.create(:user) }
  gu.gathering { Factory.create(:gathering) }
  gu.role "reader"
end

Factory.define :contributor, :class => GatheringUser do |gu|
  gu.user { Factory.create(:user) }
  gu.gathering { Factory.create(:gathering) }
  gu.role "contributor"
end

Factory.define :owner, :class => GatheringUser do |gu|
  gu.user { Factory.create(:user) }
  gu.gathering { Factory.create(:gathering) }
  gu.role "owner"
end