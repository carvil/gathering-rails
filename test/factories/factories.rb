
## Gathering Factory ##
Factory.define :gathering, class: Gathering do |g|
  g.name          "gathering %d"
  g.description   "%{name} description"
  g.location      "somewhere out there %d"
end

## Event Factory ##
Factory.define :event, class: Event do |e|
  e.title           "event %d"
  e.description     "%{title} description"
  e.scheduled_date  "#{DateTime.now}"
  e.gathering       { Factory :gathering }
  e.location        { |ev| "#{ev.gathering.location} event" }
end
