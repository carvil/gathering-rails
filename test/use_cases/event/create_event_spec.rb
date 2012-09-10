require 'test_helper'

include UseCases

describe EventUseCase do
  describe "create" do    
    def valid_attributes
      {
        :title => "Main Ceremony",
        :description => "The main ceremony which will contain all the fun stuff",
        :location => "Special venue, Anywhere, USA",
        :scheduled_date => "6/1/2013 17:00"
      }
    end
    
    def gathering
      Factory.create(:gathering)
    end
  
    it "successfully creates and persists a new Event" do
      gathering_loc = gathering
      response = EventUseCase.new(:atts => valid_attributes, :gathering => gathering_loc).create
      
      response.ok?.must_equal(true)
      event = response.event
      event.id.wont_be_nil
      event.title.must_equal(valid_attributes[:title])
      event.description.must_equal(valid_attributes[:description])
      event.location.must_equal(valid_attributes[:location])
      event.scheduled_date.must_equal(Time.zone.parse(valid_attributes[:scheduled_date]))
      event.gathering.must_equal(gathering_loc)
      
    end
    
    it "returns errors if the create Gathering request is not valid" do
      response = EventUseCase.new(:atts => valid_attributes.merge(:title => ""), :gathering => gathering).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes.merge(:description => ""), :gathering => gathering).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes.merge(:location => ""), :gathering => gathering).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes.merge(:scheduled_date => ""), :gathering => gathering).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes, :gathering => nil).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes.merge(:cancelled_at => ""), :gathering => gathering).create
      response.ok?.must_equal(true)
      response.errors.must_be_nil
    end
    
    it "returns errors if creating an event with a duplicate title and the same gathering" do
      event_orig = EventUseCase.new(:atts => valid_attributes).create.event
      response = EventUseCase.new(:atts => valid_attributes.merge(:title => event_orig.title), :gathering => event_orig.gathering).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
end
