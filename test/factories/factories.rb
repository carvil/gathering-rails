
## Gathering Factory ##
Factory.define :gathering, class: Gathering do |g|
  g.name          "gathering %d"
  g.description   "%{name} description"
  g.location      "somewhere out there %d"
end
